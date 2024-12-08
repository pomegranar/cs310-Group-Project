# DKU Sports Complex Management System

Group project for the Computer Science 310 – Introduction to Databases course at Duke Kunshan University.

Team members are: Anar, Doniyor, Sean

# How to Install & Run:

## 1. How to Get Started

### Cloning the Repo

```bash
git clone https://github.com/pomegranar/cs310-Group-Project.git
```

### Dependencies

Assuming you have the latest versions of Python and MySQL installed, we recommend you set up a Python **virtual environment** to isolate dependencies.

```bash
python -m venv venv
```

You can then _activate_ it with the following command:

on macOS/Linux:

```bash
source venv/bin/activate
```

on Windows Powershell:

```powershell
./.venv/Scripts/Activate.ps1
```

on Windows CMD:

```powershell
./.venv/Scripts/Activate.bat
```

After you _activate_ the virtual environment, you can run the following command to tell Pip to download the necessary libraries:

```bash
pip install -r requirements.txt
```

You can peek into `requirements.txt` to see all dependencies if you wish.

## 2. Set Up the Database

Once you get MySQL running, you can run the following SQL commands from the project folder to initialize and populate the database:

```MySQL
SOURCE queries/new_schema.sql;
```

```MySQL
SOURCE queries/fill_data.sql;
```

## 3. Run app.py

After all the setup is complete, just run the following:

```bash
python app.py
```

which will prompt you for your database password and start the local site on port 5000.

# Development:

## Timeline

- [x] 28/10: project topic approval deadline.
- [x] 03/11: software requirements specification document submission.
- [x] 10/11: database design document submission.
- [ ] 05/12 : project presentation.
- [ ] 08/12: report submission and peer group assessment submission.

## Development Roadmap

- [ ] Define new features to add.
    - [ ] Saving logs as a JSON file.
    - [ ] Space reservations (+schedule conflict checks via trigger).
    - [ ] Class registration/check-in.

# Project Presentation

https://www.canva.com/design/DAGYVWdw728/etnBaLe7sTOUbEIrf3ecmw/edit?utm_content=DAGYVWdw728&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton

# Project Report

Overleaf link:
https://www.overleaf.com/6913953676czmjhfqhybgb#6d925c

# HW4:

- [ ] Design E-R model with ER diagram.
- [ ] Define attributes for each table.
- [ ] Init Report (add the diagram).
- [ ] Refactor database schema to fit the new E-R model.
- [ ] Fill new tables.
- [ ] Finish implementing features in Python.
- [ ] Redesign the user interface.

# Database Design:

Sports Complex IMS Database Design Document
Google Docs link with edit access:
https://docs.google.com/document/d/1gv8seOHcQIo4mhCA1abxsu-VML-hen7Qq4Lq1JHkTHk/edit?usp=sharing

## Tables

- [ ] Users
- [ ] Equipment
- [ ] Notifications (email to users)

## User types

- [ ] Student
- [ ] Faculty
- [ ] Lifeguard
- [ ] Affiliates/Family of faculty
- [ ] Worker
- [ ] Student worker
- [ ] Climbing wall staff
- [ ] Security guard

## Improvements

- Automatically approve facility requests.
- Closing announcement thing.
- Tapping card should automatically enter it into the required text field.
- Typing to search for equipment to check out should not be required. Everything should be buttons.

# SRS

## Required Sections for the Software Requirements Specification:

- [ ] Introduction.
      This describes the **need for the system**. It should briefly describe the system’s functions and explain **how it will work with other systems**. It should also describe how the system **fits into the overall business or strategic objectives** of the organization commissioning the software.
- [ ] User requirements definition.
      Here, you describe the **services provided for the user**. The nonfunctional system requirements should also be described in this section. This description may use natural language, diagrams, or other notations that are understandable to customers. Product and process standards that must be followed should be specified.
- [ ] System requirements specification.
      This describes the functional and non-functional requirements in more detail. If necessary, further detail may also be added to the nonfunctional requirements. Interfaces to other systems may be defined.
- [ ] System models.
      This chapter includes graphical system models showing the relationships between the system components and the system and its environment. Examples of possible models are object models, data-flow models, or semantic data models.

## Collaborative Google Doc Link:

https://docs.google.com/document/d/1d3XCcXY8Gzw8mQ4DGygr_bhmYVCxuQA_0WF4ub9iIrc/edit?usp=sharing

# Project Proposal (Finished and approved)

Google Doc link (anyone with the link can edit):
https://docs.google.com/document/d/1NMYmtUHWWL7xNTXi5h011cDegPWQqB8o7CllejP9p8k/edit?usp=sharing
