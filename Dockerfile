# Step 1: Base Image
FROM node:14

# Step 2: Set Working Directory
WORKDIR /app

# Step 3: Copy Package Files
COPY package*.json ./

# Step 4: Install Dependencies
RUN npm install

# Step 5: Copy the Rest of the Application Code
COPY . .

# Step 6: Expose Port
EXPOSE 8080

# Step 7: Run the Application
CMD ["npm", "start"]
