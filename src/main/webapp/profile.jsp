<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Profile Page</title>
    <link href="https://unpkg.com/tailwindcss@^1.0/dist/tailwind.min.css" rel="stylesheet">
</head>
<body>
    <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16 lg:py-20">
            <div class="text-center">
                <h1 class="text-4xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight mb-4">
                    Profile Page
                </h1>

                <h3 class="text-2xl">Name: <%= session.getAttribute("name") %></h3>

                <h3 class="text-2xl">Email: <%= session.getAttribute("email") %></h3>

                <h3 class="text-2xl">Student ID: <%= session.getAttribute("studentID") %></h3>

                <button id="changePasswordBtn" class="mt-4 px-6 py-2 bg-blue-500 text-white font-bold rounded hover:bg-blue-600">
                    Change Password
                </button>

                <form id="changePasswordForm" action="ChangePassword" method="post" style="display:none;">
                    <label for="currentPassword" class="block text-lg mt-4">Current Password:</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="mt-2 px-4 py-2 border border-gray-300 rounded-md" required />

                    <label for="newPassword" class="block text-lg mt-4">New Password:</label>
                    <input type="password" id="newPassword" name="newPassword" class="mt-2 px-4 py-2 border border-gray-300 rounded-md" required />

                    <button type="submit" class="mx-8 px-6 py-2 bg-blue-500 text-white font-bold rounded hover:bg-blue-600">Update Password</button>
                </form>
                
                <form action="Logout" method="post" class="mt-4">
                    <input type="submit" value="Logout" class="px-6 py-2 bg-blue-500 text-white font-bold rounded hover:bg-blue-600">
                </form>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('changePasswordBtn').onclick = function() {
            var form = document.getElementById('changePasswordForm');
            form.style.display = form.style.display === 'none' ? 'block' : 'none';
        };
    </script>
</body>
</html>
