import streamlit as st
from streamlit import session_state as ss

# Fake database for demonstration purposes
if 'users' not in ss:
    ss.users = {'admin': 'password'}
if 'tasks' not in ss:
    ss.tasks = []

def register_user(username, password):
    ss.users[username] = password
    st.success("Registered successfully!")

def authenticate_user(username, password):
    return ss.users.get(username) == password

def add_task(task):
    ss.tasks.append(task)

def delete_task(task_id):
    ss.tasks.pop(task_id)

def mark_task_done(task_id):
    ss.tasks[task_id]['done'] = True

# Define the pages
def page_authentication():
    st.subheader('Register')
    with st.form('RegisterForm'):
        new_username = st.text_input('Username')
        new_password = st.text_input('Password', type='password')
        submitted = st.form_submit_button('Register')
        if submitted:
            register_user(new_username, new_password)

    st.subheader('Login')
    with st.form('LoginForm'):
        username = st.text_input('Username')
        password = st.text_input('Password', type='password')
        submitted = st.form_submit_button('Login')
        if submitted:
            if authenticate_user(username, password):
                ss.logged_in_user = username
                st.success('Logged in successfully!')
            else:
                st.error('Username/password is incorrect')

def page_task_manager():
    st.subheader('Task Manager')
    
    # Task creation form
    with st.form('TaskForm'):
        task_desc = st.text_input('Task Description')
        task_priority = st.selectbox('Priority', ['Low', 'Medium', 'High'])
        submitted = st.form_submit_button('Add Task')
        if submitted:
            add_task({'desc': task_desc, 'priority': task_priority, 'done': False})
    
    # List tasks with options to edit, delete, mark as done
    for i, task in enumerate(ss.tasks):
        col1, col2, col3, col4 = st.columns(4)
        col1.write(task['desc'])
        col2.write(task['priority'])
        col3.checkbox('Done', task['done'], key=f'done-{i}', on_change=mark_task_done, args=(i,))
        col4.button('Delete', key=f'delete-{i}', on_click=delete_task, args=(i,))

def page_sort_tasks():
    st.subheader('Sort Tasks by Priority')
    sorted_tasks = sorted(ss.tasks, key=lambda x: x['priority'])
    for task in sorted_tasks:
        st.write(f"{task['desc']} - {task['priority']} - {'Done' if task['done'] else 'Pending'}")

# Main app logic
def main():
    st.sidebar.title("InnoTasks")
    menu = ["Authentication", "Task Manager", "Sort Tasks"]
    choice = st.sidebar.selectbox("Menu", menu)
    
    if choice == "Authentication":
        page_authentication()
    elif choice == "Task Manager":
        if 'logged_in_user' in ss:
            page_task_manager()
        else:
            st.warning("Please login to access this page")
    elif choice == "Sort Tasks":
        if 'logged_in_user' in ss:
            page_sort_tasks()
        else:
            st.warning("Please login to access this page")

if __name__ == '__main__':
    main()