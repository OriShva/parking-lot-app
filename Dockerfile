# Use Python 3.10 slim image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the rest of the application
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8080

# Use Gunicorn in production, fallback to Flask dev server
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app.main:app", "--access-logfile", "-", "--error-logfile", "-"]
