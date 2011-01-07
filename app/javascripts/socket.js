//= require "chat_room"
//= require "supervision"
//= require "s"

jQuery(function($) {

    $(".chat_room").each(function(i, element) {
        var $chatRoom = $(this);
        $chatRoom.chatRoom();

        var $form = $chatRoom.find("#new_chat_message");
        $form.bind({
            "ajax:loading": function(event) { $form.find("textarea").val(""); }
        });

        var onUserEnters = function(event, user) {
            PGS.userInfo(user.id, function(userId, userData) {
                var username = userData.name;
                $chatRoom.trigger("systemMessage", { text: "<" + username + "> enter room" });
            });
        };
        var onUserExits = function(event, user) {
            PGS.userInfo(user.id, function(userId, userData) {
                var username = userData.name;
                $chatRoom.trigger("systemMessage", { text: "<" + username + "> exit room" });
            });
        };
        var onNewMessage = function(event, message) {
            PGS.userInfo(message.user, function(userId, userData) {
                var date = new Date((+message.timestamp) * 1000);
                $chatRoom.trigger("message", _.extend(message, { date: date, user: userData.name }));
            });
        };
        $chatRoom.bind({
            "userEnters": onUserEnters,
            "userExits": onUserExits,
            "newMessage": onNewMessage
        });

        var chatRoomToken = $chatRoom.data("token");
        var chatRoomId = $chatRoom.attr("id").replace("chat_room_", "");

        var s = S(PGS.getSocket(), "chat");
        s.on("authentication", function(type, message) {
            if (message.status === "OK") {
                console.log("chat: Authenticated");
            } else {
                console.error(message);
            }
        });
        s.on("presence", function(type, message) {
            if (message.action === "enter") {
                $chatRoom.trigger("userEnters", { id: message.user });
            } else if (message.action === "exit") {
                $chatRoom.trigger("userExits", { id: message.user });
            }
        });
        s.on("message", function(type, message) {
            $chatRoom.trigger("newMessage", message);
        });
        s.onConnect(function() {
            this.send("authenticate", { userId: document.pgs.currentUser, token: chatRoomToken, chatRoom: chatRoomId });
        });
    });

    $("#supervisions_show .supervision").each(function(i, element) {
        var $supervision = $(this);
        $supervision.supervisionRoom();

        var supervisionToken = $supervision.data("token");
        var supervisionId = $supervision.attr("id").replace("supervision_", "");

        var s = S(PGS.getSocket(), "supervision");
        s.on("authentication", function(type, message) {
            if (message.status === "OK") {
                console.log("supervision: Authenticated");
            } else {
                console.error(message);
            }
        });
        s.onConnect(function() {
            this.send("authenticate", { userId: document.pgs.currentUser, token: supervisionToken, supervision: supervisionId });
        });
        s.on("supervision", function(type, message) {
            $supervision.trigger("supervisionUpdate", message.supervision);
        });
        s.on("topic", function(type, message) {
            $supervision.trigger("newTopic", message.topic);
        });
        s.on("question", function(type, message) {
            $supervision.trigger("newQuestion", message.question);
        });
        s.on("answer", function(type, message) {
            $supervision.trigger("newAnswer", message.answer);
        });
        s.on("idea", function(type, message) {
            $supervision.trigger("newIdea", message.idea);
        });
        s.on("ideas_feedback", function(type, message) {
            $supervision.trigger("newIdeasFeedback", message.ideas_feedback);
        });
        s.on("solution", function(type, message) {
            $supervision.trigger("newSolution", message.solution);
        });
        s.on("solutions_feedback", function(type, message) {
            $supervision.trigger("newSolutionsFeedback", message.solutions_feedback);
        });
    });

});
