FROM node:14

WORKDIR /app

COPY . .

RUN [ -f package.json ] && npm install || echo "No package.json, skipping npm install"

EXPOSE 8080

CMD ["node", "app.js"]

