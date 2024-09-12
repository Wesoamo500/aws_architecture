#!/bin/bash

# Update the system
yum update -y

# Install Node.js and npm
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
yum install -y nodejs

# Install TypeScript globally
npm install -g typescript

# Install a simple HTTP server
npm install -g http-server

# Create a project directory
mkdir -p /home/ec2-user/myapp
cd /home/ec2-user/myapp

# Create a simple HTML file
cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My TypeScript App</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Welcome to My TypeScript App</h1>
    <p>This is a simple web page served from an EC2 instance.</p>
    <div id="message"></div>
    <script src="app.js"></script>
</body>
</html>
EOF

# Create a CSS file
cat <<EOF > styles.css
body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    padding: 20px;
    max-width: 800px;
    margin: 0 auto;
}

h1 {
    color: #333;
}

#message {
    margin-top: 20px;
    padding: 10px;
    background-color: #f0f0f0;
    border-radius: 5px;
}
EOF

# Create a TypeScript file
cat <<EOF > app.ts
document.addEventListener('DOMContentLoaded', () => {
    const messageElement = document.getElementById('message');
    if (messageElement) {
        messageElement.textContent = 'This message was added by TypeScript!';
    }
});
EOF

# Compile TypeScript to JavaScript
tsc app.ts

# Set up a simple start script
echo '#!/bin/bash' > start-server.sh
echo 'cd /home/ec2-user/myapp && http-server -p 8080' >> start-server.sh
chmod +x start-server.sh

# Set up the server to start on boot
echo "@reboot /home/ec2-user/myapp/start-server.sh" | crontab -

# Start the server
/home/ec2-user/myapp/start-server.sh &

# Print the script completion message
echo "User data script has completed. A simple web server is now running on port 8080."