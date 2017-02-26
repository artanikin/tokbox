var apiKey    = gon.api_key;
var sessionId = gon.session_id;
var token     = gon.token;
var nikname   = gon.nikname;
var session;
var publishers;
var streamIndex = 0;

$(document).ready(function(){
  var chatForm = $("#chat_form");
  var chat = $("#chat");

  initializeSession();
  scrollDown(chat[0]);

  $("#publish_stream").on("click", function(event){
    event.preventDefault();
    publishStream();
    $(this).hide();
  });

  // Chat
  chatForm.on("ajax:success", function(e, data, status, xhr) {
    var message;
    var responseData;

    responseData = $.parseJSON(xhr.responseText);
    $(this).find("input[type=text]").val('');

    message = "<span>" + responseData.nikname + ": </span>" + responseData.message.text;
    session.signal({ type: "chat", data: message });
  });

  // Toolbox
  $("#videos").on("click", ".unpublish", function(event){
    event.preventDefault();
    var publisher_block_id = $(this).data("publisher");

    unpublishStream(publishers[publisher_block_id].stream);

    $("#toolbox_" + publisher_block_id).remove();
    $("#publish_stream").show();
  });

  $("#videos").on("click", ".unpublish_video", function(event){
    event.preventDefault();
    publisherSwitch($(this), "video", false);
  });

  $("#videos").on("click", ".publish_video", function(event){
    event.preventDefault();
    publisherSwitch($(this), "video", true);
  });

  $("#videos").on("click", ".unpublish_audio", function(event){
    event.preventDefault();
    publisherSwitch($(this), "audio", false);
  });

  $("#videos").on("click", ".publish_audio", function(event){
    event.preventDefault();
    publisherSwitch($(this), "audio", true);
  });
}); // end document ready

function initializeSession() {
  session = OT.initSession(apiKey, sessionId);
  session.connect(token);

  session.on({
    "sessionConnected":    sessionConnectedHandler,
    "sessionDisconnected": sessionDisconnectedHandler,
    "streamCreated":       streamCreatedHandler,
    "connectionCreated":   connectionCreatedHandler,
    "connectionDestroyed": connectionDestroyedHandler,
    "signal": signalHandler
  });
} // end initliazeSession()

function publishStream() {
  if (session.capabilities.publish == 1) {
    var videoId = "video_" + streamIndex;
    var propertiesPub = { name: nikname, insertMode: "append", width: "300px", height: "300px" }

    // create video container
    var video_container = $("#publisher").append($("<div id='" + videoId + "'></div>"));

    var myPublisher = session.publish(videoId, propertiesPub);
    publishers[myPublisher.id] = myPublisher;

    var toolbox = JST["templates/toolbox"]({
      publisher_id: myPublisher.id,
      can_unpublish: (session.capabilities.forceUnpublish == 1)
    })
    video_container.after(toolbox);

    streamIndex++;
  }
}

function unpublishStream(stream) {
  session.forceUnpublish(stream);
}

function sessionConnectedHandler(event) {
  publishers = {};
}

function streamCreatedHandler(event) {
  var videoId = "sub_video_" + streamIndex;
  var properties = { insertMode: "append", width: "300px", height: "300px" }

  session.subscribe(event.stream, "subscriber", properties)
}

function sessionDisconnectedHandler(event) {
  console.log("You are disconnected. ", event.reason);
}

function connectionCreatedHandler(event) {
  console.log("New connection.");
}

function connectionDestroyedHandler(event) {
  console.log("Destroyed connection.");
}

function signalHandler(event){
  var chat = $("#chat");
  var msg = document.createElement('p');

  msg.innerHTML = event.data;
  msg.className = event.from.connectionId === session.connection.connectionId ? 'mine' : 'theirs';

  chat.append(msg);
  scrollDown(chat[0]);
}

function scrollDown(elem) {
  elem.scrollTop = elem.scrollHeight;
}

function publisherSwitch(elem, setting, action) {
    var publisherBlockId = elem.data("publisher");
    var publisher = publishers[publisherBlockId];
    var methodName = "publish" + setting.charAt(0).toUpperCase() + setting.slice(1);

    publisher[methodName](action);
}
