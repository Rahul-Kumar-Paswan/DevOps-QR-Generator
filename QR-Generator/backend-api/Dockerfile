FROM python:3.9-slim

WORKDIR /app

# Copy only the necessary files to install dependencies first (for caching purposes)
COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /app/

# Expose FastAPI port
EXPOSE 80

# Start the app with Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
