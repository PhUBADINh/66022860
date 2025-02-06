# ใช้ Node.js เพื่อติดตั้ง dependencies และ build project
FROM node:18-alpine AS builder

WORKDIR /app

# คัดลอก package.json และติดตั้ง dependencies
COPY package.json package-lock.json ./
RUN npm install

# คัดลอกโค้ดทั้งหมดและ build Next.js เป็น static files
COPY . .
RUN npm run build && npm run export

# ใช้ Nginx เพื่อ serve static files
FROM nginx:latest

# คัดลอก static files ไปที่ root ของ Nginx
COPY --from=builder /app/out /usr/share/nginx/html

# คัดลอกไฟล์ default Nginx config (หากต้องการแก้ไขเพิ่มเติม)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# เปิดพอร์ต 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
