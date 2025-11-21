FROM python:3.11-slim

WORKDIR /app

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY *.py .
COPY templates ./templates
COPY frontend ./frontend

# Expose port
EXPOSE 8000

# Start command - use PORT env var if set, otherwise default to 8000
CMD sh -c "uvicorn app:app --host 0.0.0.0 --port ${PORT:-8000} --workers 4"