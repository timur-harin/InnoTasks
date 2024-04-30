# InnoTasks

InnoTasks is a feature-rich to-do list notification application designed to enhance task management for daily users. The application allows users to create and manage their to-do lists, set reminders and priorities for tasks, and receive notifications to stay organized and productive.

## Features

- User Authentication: Users can sign up for an account and securely log in to access their personalized to-do lists. Authentication mechanisms such as JWT (JSON Web Tokens) or OAuth are implemented to ensure user security.

- Task Management: Users can easily create, view, update, and delete tasks. Each task can have a title, description, due date, and priority level.

- Notification System: The application provides a robust notification system to keep users informed about upcoming tasks. Users can customize their notification preferences, such as receiving reminders at specific times or intervals.

- Task Prioritization: Users can assign priority levels to tasks, helping them manage their workload effectively. Priority levels may include options like high, medium, and low.

- Responsive Design: The application features a responsive design, ensuring usability across different devices and screen sizes. The user interface is intuitive, providing a seamless experience for users.

## Demo 

https://github.com/timur-harin/InnoTasks/assets/88401434/cfd2feba-6681-40b8-8b69-2292902a784e

## Screens 

### Register page // login page 

![register_page](https://github.com/timur-harin/InnoTasks/assets/88401434/670cbe66-fba6-42ef-accb-d354d59553a1)

### Viewing the tasks 

![view_tasks](https://github.com/timur-harin/InnoTasks/assets/88401434/fb5f3e57-5e8a-41e9-a982-9788d132c0c2)

### Creating the task

![create_task](https://github.com/timur-harin/InnoTasks/assets/88401434/79ede50e-e462-4397-8589-e07054bfb45e)

### Updating the task

![update_task](https://github.com/timur-harin/InnoTasks/assets/88401434/c47a9ce5-3bf7-4423-922d-945fe62ebc3d)

### Deleting the task 

![delete_task](https://github.com/timur-harin/InnoTasks/assets/88401434/0cf40f93-29a9-41e7-a6b5-a9384b5cfc85)

## Installation and Usage

To run the InnoTasks application using Docker Compose, follow these steps:

1. Ensure Docker and Docker Compose are installed on your machine.

2. Clone the repository:

```bash 
git clone https://github.com/timur-kharin/InnoTasks.git
```

3. Navigate to the project directory:

```bash 
cd InnoTasks
```

4. Run the following command to start the application:

```bash 
sh run.sh
```

This command will build the Docker images for the backend and frontend, start the containers, and set up the necessary network connections.

5. Access the InnoTasks application in your web browser at `http://localhost`.

## Technologies Used

- Frontend: Flutter
- Backend: Python, RestAPI

## Contributing

Contributions to InnoTasks are welcome! If you find a bug or have a feature request, please open an issue on the GitHub repository. If you would like to contribute code, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make the necessary changes in your branch.
4. Commit your changes and push the branch to your forked repository.
5. Submit a pull request to the main repository.

## License

This project is licensed under the [MIT License](LICENSE).

