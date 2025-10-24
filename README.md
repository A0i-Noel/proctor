# Survey Platform Enhancement — Coding Challenge Submission

**Submitted by:** Aoi Kuriki  
**Completion Date:** October 24, 2025  
**Forked Repository:** [https://github.com/A0i-Noel/proctor](https://github.com/A0i-Noel/proctor)

---

## How to Run Locally

```bash
# 1. Install dependencies
bundle install
yarn install

# 2. Setup the database
bin/rails db:create db:migrate db:seed

# 3. Start the development server
bin/dev

# Then open your browser to:
http://localhost:3000/surveys
```

You can:

- Create and manage roles

- Add a survey and questions

- Assign target roles to questions

- Take surveys as different roles

- View role-filtered response results

---

## Project Overview

This implementation extends the base survey platform to support role-based visibility, grouped submissions, analyzing responses per roles, and soft deletion.
It enhances both the question creation experience and data analytics capabilities.

## Usage Instructions

### Questioner (Company Side)

1. **Manage Roles:**  
   Start by setting available roles using the **“Manage Role”** button (`/role`).

2. **Create Questions:**  
   When adding a new question, you can specify which roles it targets.  
   - Leaving all roles unchecked will make the question visible to **everyone**.

3. **View Responses:**  
   For each survey, you can open **“Responses”** to view all submissions per candidate.  
   - You can filter responses by role.  
   - The system uses **soft-delete** for roles, meaning even if a role is deleted or edited later, its related responses will still be visible.

---

### Respondent (Developer Side)

1. **Role Selection:**  
   Each survey begins by asking for the respondent’s role (this question always appears first, regardless of other question order).

2. **Filtered Questions:**  
   Based on the selected role, the respondent will only see questions relevant to them.

---

## Idea per target audience

Questioner (company side): Set and manege the role globally and filter the response per roles. For the future extension, setting color schema to each role will help visually compare the responses with any graphs.

Respondent (Developer side): Only the necessary question will be visible, and if they have auth to record the role in their user object, they can see only the necessary survey in the future.

---

## Features Implemented

### 1. Role-Based Question Targeting
- Each question can now specify one or more target roles.
- Target role IDs are stored in `questions.target_role_ids` as an array.
- Questions without target roles are visible to all respondents.
#### Changes:
- `QuestionsController` and `question_params` updated.
- `questions/_form.html.erb` now includes role checkboxes.
- `SurveysController#take` serializes role targeting info for the React component.
- Visibility logic added to the React `TakeSurvey` component.

### 2. Dynamic Role Visibility During Survey Taking
- The respondent selects a single role at the top of the survey.
- Questions dynamically appear or disappear based on the selected role.
- Required fields are ignored if hidden, preventing submission errors.

### 3. Submission and Response Grouping
- Each completed survey generates:
   - A single Submission record.
   - Multiple Response records linked to that submission.
__Schema Additions:__

```ruby
create_table :submissions do |t|
  t.references :survey, null: false, foreign_key: true
  t.references :role, foreign_key: true
  t.timestamps
end

add_reference :responses, :submission, foreign_key: true
```

__Controller Updates:__
ResponsesController#create now:
- Creates a Submission tied to the selected role.
- Creates multiple Response records within a single transaction.

### 4. Response Dashboard and Analytics
- Added `ResponsesController#index` to display grouped submissions.
- Responses are organized per submission block.
- A total count of submissions is shown by role.
- Added role filter buttons (`All`, plus each role) to filter visible responses.
- Includes empty-state handling (“No responses submitted.”).

### 5. Soft-Delete Roles
Soft deletion allows deactivating roles while preserving history in responses and submissions.