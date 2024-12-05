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
<body class="min-h-screen bg-gradient-to-br from-purple-500 to-blue-600 flex items-center justify-center">
     <div class="bg-white rounded-lg shadow-xl w-full max-w-md overflow-hidden">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            <div class="text-center">
                <h1 class="text-2xl font-bold text-center mb-2">Profile Page</h1>

                <h3 class="text-gray-600 text-center">Name: <%= session.getAttribute("name") %></h3>

                <h3 class="text-gray-600 text-center">Email: <%= session.getAttribute("email") %></h3>

                <h3 class="text-gray-600 text-center">Student ID: <%= session.getAttribute("studentID") %></h3>
                <form action="homepage.jsp" method="get">
                    <button class="mt-3 w-full bg-blue-600 text-white rounded-md py-2 px-4 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
                        Home Page
                    </button>
                </form>
                <button id="changePasswordBtn" class="mt-3 w-full bg-blue-600 text-white rounded-md py-2 px-4 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
                    Change Password
                </button>

                <form id="changePasswordForm" action="ChangePassword" method="post" style="display:none;">
                    <label for="currentPassword" class="block text-lg mt-4">Current Password:</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="w-full mt-2 px-4 py-2 border border-gray-300 rounded-md" required />

                    <label for="newPassword" class="block text-lg mt-4">New Password:</label>
                    <input type="password" id="newPassword" name="newPassword" class="w-full mt-2 px-4 py-2 border border-gray-300 rounded-md" required />

                    <button type="submit" class="mt-4 w-full bg-blue-600 text-white rounded-md py-2 px-4 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
                    Update Password
                    </button>
                </form>
                
                <form action="Logout" method="post" class="mt-4">
                    <input type="submit" value="Logout" class="w-full bg-gray-200 text-gray-800 rounded-md py-2 px-4 hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 transition-colors flex items-center justify-center">
                </form>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('changePasswordBtn').onclick = function() {
            var form = document.getElementById('changePasswordForm');
            var button = document.getElementById('changePasswordBtn');
            
            if (form.style.display === 'none') {
                form.style.display = 'block';
                button.textContent = 'Back';
            } else {
                form.style.display = 'none';
                button.textContent = 'Change Password';
            }
        };
    </script>
</body>
</html>
