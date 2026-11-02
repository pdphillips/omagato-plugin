import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
  id: root

  property bool online: false
  property int brightness: 0
  property string profileName: ""
  property int page: 0
  property string summary: "Omagato offline"
  property var pending: ({})
  property int nextId: 1

  function socketPath() {
    var runtime = Quickshell.env("XDG_RUNTIME_DIR")
    if (!runtime || runtime.length === 0) runtime = "/tmp"
    return runtime + "/omagato.sock"
  }

  function request(method, params, cb) {
    var id = root.nextId++
    if (cb) {
      var copy = ({})
      for (var k in root.pending) copy[k] = root.pending[k]
      copy[String(id)] = cb
      root.pending = copy
    }
    var msg = {
      protocolVersion: 1,
      id: id,
      method: method,
      params: params || ({})
    }
    sock.write(JSON.stringify(msg) + "\n")
    sock.flush()
  }

  function ingest(line) {
    var text = String(line || "").replace(/^\s+|\s+$/g, "")
    if (!text.length) return
    var msg
    try { msg = JSON.parse(text) } catch (e) { return }
    if (!msg || msg.id === undefined) return
    var id = String(msg.id)
    var cb = root.pending[id]
    if (!cb) return
    var copy = ({})
    for (var k in root.pending) if (k !== id) copy[k] = root.pending[k]
    root.pending = copy
    cb(msg)
  }

  function refresh() {
    root.request("status", {}, function(msg) {
      if (!msg.ok) {
        root.online = false
        root.summary = msg.error || "Omagato error"
        return
      }
      var result = msg.result || ({})
      root.online = true
      root.brightness = result.brightness || 0
      root.profileName = result.profile || ""
      root.page = result.page || 0
      var devices = result.devices || []
      var names = []
      for (var i = 0; i < devices.length; i++) {
        var dev = devices[i]
        names.push((dev.name || "device") + (dev.connected ? "" : " down"))
      }
      var deviceLine = names.length ? names.join(", ") : "no devices"
      root.summary = root.profileName + " · page " + (root.page + 1) + " · " + root.brightness + "% · " + deviceLine
    })
  }

  function trigger(name) {
    root.request("trigger", { name: name }, function() { root.refresh() })
  }

  function reconnect() {
    sock.connected = false
    sock.connected = true
    root.request("reconnect", {}, function() { root.refresh() })
  }

  // QtObject has no default property in Quickshell 0.3.2, so these cannot be children.
  property Socket connection: Socket {
    id: sock
    path: root.socketPath()
    connected: true
    onConnectionStateChanged: {
      root.online = sock.connected
      if (sock.connected) root.refresh()
      else root.summary = "Omagato offline"
    }
    parser: SplitParser {
      splitMarker: "\n"
      onRead: function(line) { root.ingest(line) }
    }
  }

  property Timer poll: Timer {
    interval: 2000
    repeat: true
    running: sock.connected
    onTriggered: root.refresh()
  }
}
