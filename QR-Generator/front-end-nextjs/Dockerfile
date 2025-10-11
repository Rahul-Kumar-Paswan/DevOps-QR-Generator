# Build Stage
FROM node:18-alpine AS build

WORKDIR /app

# Install dependencies using npm ci for a clean install
COPY package*.json ./
RUN npm ci

# Copy the rest of the source code and build the application
COPY . . 
RUN npm run build

# Production Stage
FROM node:18-alpine AS production

WORKDIR /app

# Copy the necessary files from the build stage
COPY --from=build /app/.next /app/.next
COPY --from=build /app/public /app/public
COPY --from=build /app/package.json /app/package.json
COPY --from=build /app/node_modules /app/node_modules
COPY --from=build /app/next.config.js /app/next.config.js

# Set environment variables for production
ENV NODE_ENV=production

EXPOSE 3000

# Run the Next.js app in production mode
CMD ["npm", "start"]
