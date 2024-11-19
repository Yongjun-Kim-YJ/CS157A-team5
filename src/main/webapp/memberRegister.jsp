<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In / Register</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
        <h2 id="form-title" class="text-2xl font-bold mb-6 text-center text-gray-800">Sign In</h2>
        
        <!-- Sign-In Form -->
        <form method="post" id="login-form" action="Login" class="space-y-4">
            <div>
                <label for="login-studentID" class="block text-sm font-medium text-gray-700">Student ID:</label>
                <input type="text" id="login-studentID" name="login-studentID" placeholder="Enter your student ID" required class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
            </div>
            <div>
                <label for="login-password" class="block text-sm font-medium text-gray-700">Password:</label>
                <input type="password" id="login-password" name="login-password" placeholder="Enter password" required class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
            </div>
            <div>
                <input type="submit" value="Sign In" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            </div>
            <div class="text-center mt-4">
                <span class="text-sm text-gray-600">Don't have an account?</span>
                <button type="button" onclick="toggleForms()" class="ml-2 text-sm text-indigo-600 hover:text-indigo-500">Register</button>
            </div>
        </form>

        <!-- Registration Form (Hidden by default) -->
        <form action="Register" method="post" id="register-form" class="hidden space-y-4">
            <div>
                <label for="studentID" class="block text-sm font-medium text-gray-700">StudentID:</label>
                <input type="text" id="username" name="studentID" placeholder="Enter student ID" required class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
            </div>
            <div>
                <label for="name" class="block text-sm font-medium text-gray-700">Name:</label>
                <input type="text" id="username" name="name" placeholder="Enter name" required class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
            </div>
            <div>
                <label for="email" class="block text-sm font-medium text-gray-700">Email:</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
            </div>
            <div>
                <label for="password" class="block text-sm font-medium text-gray-700">Password:</label>
                <input type="password" id="password" name="password" placeholder="Enter password" required class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
            </div>

            <div>
                <input type="submit" value="Register" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            </div>
            <div class="text-center mt-4">
                <span class="text-sm text-gray-600">Already have an account?</span>
                <button type="button" onclick="toggleForms()" class="ml-2 text-sm text-indigo-600 hover:text-indigo-500">Sign In</button>
            </div>
        </form>
    </div>

    <script>
        function toggleForms() {
            const loginForm = document.getElementById('login-form');
            const registerForm = document.getElementById('register-form');
            const formTitle = document.getElementById('form-title');
            
            loginForm.classList.toggle('hidden');
            registerForm.classList.toggle('hidden');
            formTitle.textContent = loginForm.classList.contains('hidden') ? 'Register' : 'Sign In';
        }
    </script>
</body>
</html>