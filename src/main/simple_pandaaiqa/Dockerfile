# Use Python 3.8 slim image as base
FROM python:3.8-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create directory structure
RUN mkdir -p /app/simple_pandaaiqa

# Copy the application files
COPY __init__.py /app/simple_pandaaiqa/
COPY api.py /app/
COPY text_processor.py /app/simple_pandaaiqa/
COPY pdf_processor.py /app/simple_pandaaiqa/
COPY video_processor.py /app/simple_pandaaiqa/
COPY image_processor.py /app/simple_pandaaiqa/
COPY embedder.py /app/simple_pandaaiqa/
COPY vector_store.py /app/simple_pandaaiqa/
COPY generator.py /app/simple_pandaaiqa/
COPY summarize_generator.py /app/simple_pandaaiqa/
COPY role_generators.py /app/simple_pandaaiqa/
COPY config.py /app/simple_pandaaiqa/
COPY npu_generator.py /app/simple_pandaaiqa/
COPY app.py /app/simple_pandaaiqa/

# Copy utils directory
COPY utils/ /app/simple_pandaaiqa/utils/

# Copy static files
COPY static/ /app/simple_pandaaiqa/static/

# Ensure knowledge base directory exists
RUN mkdir -p /app/simple_pandaaiqa/knowledgeBase

# Add the current directory to PYTHONPATH
ENV PYTHONPATH=/app

# Set environment variables for Docker
ENV HOST="0.0.0.0"
ENV PORT=5000
ENV LM_STUDIO_API_BASE="http://host.docker.internal:1234"

# Expose the port the app runs on
EXPOSE 5000

# Command to run the application
CMD ["python", "-m", "uvicorn", "api:app", "--host", "0.0.0.0", "--port", "5000"] 