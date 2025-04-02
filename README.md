# StockRecommenderForBeginner

## Project Overview
Investing can be intimidating for beginners due to the overwhelming amount of information—news, short videos, and endless data. **StockRecommenderForBeginner** is an AI-powered platform designed to simplify the investment process for beginners. It provides stock details, price trends, market news, and answers to finance-related questions. The platform also features a **RAG-based local knowledge base**, allowing users to export insights with one click and interact with it through Q&A. You can upload files in almost any format—text, images, videos, and more—into the knowledge base, where it automatically generates summaries. Our mission is to help beginners confidently kickstart their investment journey!

### Tech Stack 
The application is built with the following components:

- **Backend**: A Java-based Spring Boot Maven project.
- **Knowledge Base**: A Python-based RAG (Retrieval-Augmented Generation) system.
- **Database**: MySQL for storing data.
- **Frontend**: React and JSP

### Prerequisites
To run the application, ensure you have the following installed:
- **Java**: Required for the Spring Boot backend.
- **Maven**: Used to build and manage the Java project.
- **Python**: Necessary for the RAG knowledge base.
- **MySQL**: Must be installed and running.
- **API keys**: In the `application.properties` file, include:
     - Your **MySQL database password**.
     - **OpenRouter API key** (for external AI models).
     - **Polygon API key** (for real-time stock data retrieval).
---
(Optional) **Docker**: It is optional but recommended for containerizing the RAG knowledge base.

Install these tools on your system before proceeding. **If you do not want to use the Knowledge Base, then docker is not needed.**



## AI Chat Functionality
The **AI Chat** feature provides flexible options for users:
- **Local Models**: Run any model locally using **LM Studio**. We recommend the **LLaMA 3.2 1B model** for beginners due to its ease of use and efficiency.
- **External Models**: Connect to the **OpenRouter API** to access powerful external large language models for enhanced performance.

This dual-mode setup lets you choose the best option based on your needs and available resources.
### Using AI Chat
To chat only in local, we use **LM Studio**. Here’s how to set it up:
1. Download and install **LM Studio** from [lmstudio.ai](https://lmstudio.ai/).
2. Load the **LLaMA 3.2 1B model** (recommended for beginners).
3. Start the model and run the server.



## Docker Integration
Docker support is included to streamline the RAG knowledge base setup. To enable it, follow these steps:

 **Configure Docker**:
   - Edit the `docker-compose.yml` file and add your **MySQL database password**.
   - Update the `application-docker.properties` file with matching database credentials.




# Starting the Application
Follow these steps to launch the app:

## Starting the java app only in local:

0. **Start the MySQL Server**:
   - Update the mysql password in the `application.properties` file.
   - Verify the database schema exists. If not, run the `create_all_tables.sql` script to set up the required tables.
1. **Install Maven**:
   - Ensure Maven is installed.
   - Run `mvn clean install` to build the project.
2. **Start the Server**:
   - Use `mvn spring-boot:run` to launch the application.
3. **Test the Application**:
   - Open a browser and go to `localhost:8080` to confirm it’s running.

### Database Check Tool
A handy tool is available at the bottom of the **Login page** to inspect your data. Alternatively, use a database workbench to view it directly.








## Starting the fully functional app with Docker Compose

Docker Compose is a tool that allows you to define and run multi-container Docker applications with a single command. In this project, it simplifies the setup of the RAG knowledge base. Here’s how to start it:

#### Prerequisites
Before running the command, make sure you have the following ready:

- **Docker**: Installed on your system. If you don’t have it, download and install it from [docker.com](https://www.docker.com/get-started).
- **docker-compose.yml**: This file should be in your project directory and configured with your MySQL database password.
- **application-docker.properties**: Updated with the correct database credentials to match `docker-compose.yml`.

#### Command to Start Docker Compose
Open your terminal, navigate to the directory containing `docker-compose.yml`, and run:

```bash
docker-compose build
```
(This might take times...)
```bash
docker-compose up
```
- **`docker-compose up`**: This builds (if needed) and starts all the containers defined in the `docker-compose.yml` file.


#### What Happens Next?
Once you execute the command:
- Docker Compose will pull any required images (e.g., MySQL, RAG services) from Docker Hub if they’re not already on your system.
- It will then start the containers as specified in the configuration.
- Always check the containers in Docker Desktop to make sure they are running.


#### Stopping the Containers
When you’re done, you can stop and remove the containers with:

```bash
docker-compose down
```

This cleanly shuts down the services and removes the containers, though your data will persist if you’ve configured volumes in `docker-compose.yml`. You can also use `system prune` to clear the cache and volume if needed.

---

That’s it! With the `docker-compose up` command, you’ll have your project’s containers up and running in no time. Let me know if you need help troubleshooting!

