# Multi-stage Dockerfile for Ocean Pulse
FROM node:20-alpine AS builder

WORKDIR /app

# Install build dependencies
COPY package*.json ./
COPY packages/shared/package*.json ./packages/shared/
COPY apps/api/package*.json ./apps/api/
COPY apps/web/package*.json ./apps/web/

RUN npm install

# Copy source files
COPY packages/shared/ ./packages/shared/
COPY apps/api/ ./apps/api/
COPY apps/web/ ./apps/web/

# Generate Prisma Client & Build all workspaces
RUN npm run build

# Runtime Stage
FROM node:20-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3001

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/packages/shared/dist ./packages/shared/dist
COPY --from=builder /app/packages/shared/package.json ./packages/shared/package.json
COPY --from=builder /app/apps/api/dist ./apps/api/dist
COPY --from=builder /app/apps/api/prisma ./apps/api/prisma
COPY --from=builder /app/apps/api/package.json ./apps/api/package.json
COPY --from=builder /app/apps/web/dist ./apps/web/dist

EXPOSE 3001

CMD ["node", "apps/api/dist/index.js"]
