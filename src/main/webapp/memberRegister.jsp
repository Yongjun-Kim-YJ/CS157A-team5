<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sign In / Register</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px auto;
            max-width: 400px;
            padding: 10px;
            background-color: #f4f4f4;
        }
        table {
            width: 100%;
        }
        td {
            padding: 10px;
        }
        input[type="text"], input[type="password"], input[type="email"], input[type="tel"] {
            width: 100%;
            padding: 8px;
            margin: 4px 0;
            box-sizing: border-box;
        }
        input[type="submit"], button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
        }
        input[type="submit"]:hover, button:hover {
            background-color: #45a049;
        }
        .hidden {
            display: none;
        }
        .toggle-container {
            text-align: center;
            margin-top: 10px;
        }
        button {
            margin-left: 10px;
        }
    </style>
</head>
<body>

    <h2 id="form-title">Sign In</h2>
    
    <!-- Sign-In Form -->
    <form action="welcome.jsp" method="post" id="login-form">
        <table>
            <tr>
                <td><label for="login-email">Email:</label></td>
                <td><input type="text" id="login-email" name="email" placeholder="Enter your email" required></td>
            </tr>
            <tr>
                <td><label for="login-password">Password:</label></td>
                <td><input type="password" id="login-password" name="password" placeholder="Enter password" required></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Sign In"></td>
            </tr>
        </table>
        <div class="toggle-container">
            <span>Don't have an account?</span>
            <button type="button" onclick="toggleForms()">Register</button>
        </div>
    </form>
    <!-- Registration Form (Hidden by default) -->
    <form action="welcome.jsp" method="post" id="register-form" class="hidden">
        <table>
            <tr>
                <td><label for="uname">User Name:</label></td>
                <td><input type="text" id="uname" name="uname" placeholder="Enter username" required></td>
            </tr>
            <tr>
                <td><label for="password">Password:</label></td>
                <td><input type="password" id="password" name="password" placeholder="Enter password" required></td>
            </tr>
            <tr>
                <td><label for="email">Email:</label></td>
                <td><input type="email" id="email" name="email" placeholder="Enter your email" required></td>
            </tr>
            <tr>
                <td><label for="phone">Phone:</label></td>
                <td><input type="tel" id="phone" name="phone" placeholder="Enter phone number" pattern="[0-9]{10}" required></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Register"></td>
            </tr>
        </table>
        <div class="toggle-container">
            <span>Already have an account?</span>
            <button type="button" onclick="toggleForms()">Sign In</button>
        </div>
    </form>

    <script>
        function toggleForms() {
            // Toggle between sign-in and register forms
            var loginForm = document.getElementById('login-form');
            var registerForm = document.getElementById('register-form');
            var formTitle = document.getElementById('form-title');
            
            if (loginForm.classList.contains('hidden')) {
                loginForm.classList.remove('hidden');
                registerForm.classList.add('hidden');
                formTitle.textContent = 'Sign In';
            } else {
                loginForm.classList.add('hidden');
                registerForm.classList.remove('hidden');
                formTitle.textContent = 'Register';
            }
        }
    </script>

</body>
</html>
