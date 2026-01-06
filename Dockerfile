# 1. ใช้ Node.js เป็นฐาน
FROM node:20-alpine AS builder

# 2. ตั้งโฟลเดอร์ทำงาน
WORKDIR /app

# 3. คัดลอกไฟล์ package เพื่อลง dependencies
COPY package*.json ./
RUN npm install

# 4. คัดลอกโค้ดทั้งหมดและ Build โปรเจกต์ (NestJS)
COPY . .
RUN npm run build

# --- Stage สำหรับรันจริง (เพื่อให้ Image มีขนาดเล็ก) ---
FROM node:20-alpine
WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# เปิดพอร์ต 3000
EXPOSE 3000

# คำสั่งรัน NestJS
CMD ["node", "dist/main"]