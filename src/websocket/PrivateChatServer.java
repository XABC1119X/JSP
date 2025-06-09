package websocket;

import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import java.util.concurrent.ConcurrentHashMap;
import java.util.*;

@ServerEndpoint("/private/{user}")
public class PrivateChatServer {
    private static Map<String, Session> userSessions = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("user") String user) {
        userSessions.put(user, session);
        System.out.println("User connected: " + user);
    }

    @OnMessage
    public void onMessage(String message, Session session, @PathParam("user") String sender) {
        String[] parts = message.split(":", 2); // 期望格式：recipient:messageText
        if (parts.length < 2) return;

        String recipient = parts[0].trim();
        String msgText = parts[1].trim();

        Session recipientSession = userSessions.get(recipient);
        if (recipientSession != null && recipientSession.isOpen()) {
            recipientSession.getAsyncRemote().sendText(sender + ": " + msgText);
        }

        // 自己也顯示
        session.getAsyncRemote().sendText("你對 " + recipient + ": " + msgText);
    }

    @OnClose
    public void onClose(Session session, @PathParam("user") String user) {
        userSessions.remove(user);
    }
}
