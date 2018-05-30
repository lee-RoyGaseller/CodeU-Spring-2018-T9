<%@ page import="codeu.model.store.basic.UserStore" %>
<%@ page import="codeu.model.data.User" %>
<%@ page import="codeu.model.data.Message" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.time.Instant" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.ZoneId" %>
<%
/** Gets the UserStore instance to access all users. */
UserStore userStore = UserStore.getInstance();
%>

<!DOCTYPE html>
<html>
<head>
  <title>User Profile Page</title>
  <link rel="stylesheet" href="/css/main.css">
</head>
<body>

  <%@include file= "navbar.jsp"%>

  <div id="container">
    <div
      style="width:75%; margin-left:auto; margin-right:auto; margin-top: 50px;">

      <%
      String currentUser = (String) request.getSession().getAttribute("user");
      String profileUser = (String) request.getAttribute("profilePage");
      User thisUser = userStore.getUser(profileUser);

      if (profileUser.equals("")) { %>
        <h1>User does not exist.</h1>

      <% } else {
        if (currentUser != null && currentUser.equals(profileUser)) { %>
            <h1 style="color:dodgerblue">Welcome to your page!</h1>
        <% } else { %>
            <h1 style="color:dodgerblue">Welcome to <%= profileUser %>'s Page!</h1>
        <% } %>
        <% /** Gets the bio of this user to display on their profile page */ %>
            <% String profilePageBio = thisUser.getBio(); %>
            <h2 style="color:skyblue">About Me</h2>
            <a> <%= profilePageBio %> </a>
            <br/>
            <br/>
        <% if (currentUser != null && currentUser.equals(profileUser)) { %>
            <% /** Gives current user a form that allows them to edit their own bio */ %>
                <a> Edit your bio here! (only you can see this) </a>
                <form action="/users/<%= currentUser %>" method="POST">
                    <input type="text" name="bio" value="<%= thisUser.getBio() %>" >
                    <br/>
                <button type="submit">Submit</button>
                </form>
         <% } %>
         <h2 style="color:skyblue"> <%= profileUser %>'s Sent Messages </h2>
         <% List<Message> userMessages = (List) request.getAttribute("messages");
            Instant instant = null;
            LocalDateTime localDate = null;
            for (Message m: userMessages) {
                instant = m.getCreationTime();
                localDate = LocalDateTime.ofInstant(instant, ZoneId.systemDefault());
                int hour = localDate.getHour();
                String timeAMPM = "";
                if (hour > 12) {
                    hour = hour % 12;
                    timeAMPM = "PM";
                } else {
                    timeAMPM = "AM";
                }
                String date = localDate.getMonth().toString() + " " + localDate.getDayOfMonth() + ", " + localDate.getYear() + " - " + hour + ":" + localDate.getMinute() + " " + timeAMPM;
                %>
                <a> <%= date %> : <%= m.getContent() %> </a>
                <br/>
            <% } %>
      <% } %>


    </div>
  </div>
</body>
</html>
