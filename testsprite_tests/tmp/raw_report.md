
# TestSprite AI Testing Report(MCP)

---

## 1️⃣ Document Metadata
- **Project Name:** PROFEPLAN
- **Date:** 2026-01-26
- **Prepared by:** TestSprite AI Team

---

## 2️⃣ Requirement Validation Summary

#### Test TC001 Successful user login with valid credentials
- **Test Code:** [TC001_Successful_user_login_with_valid_credentials.py](./TC001_Successful_user_login_with_valid_credentials.py)
- **Test Error:** Login test with valid credentials failed. The system returned an error message indicating incorrect email or password despite using valid credentials. User could not be authenticated or redirected to the dashboard. Task is incomplete due to login failure.
Browser Console Logs:
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/token?grant_type=password:0:0)
[ERROR] Auth Error: AuthApiError: Invalid login credentials
    at handleError2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4255:9)
    at async _handleRequest2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4296:5)
    at async _request (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4280:16)
    at async SupabaseAuthClient.signInWithPassword (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:5024:15)
    at async handleEmailAuth (http://localhost:3001/src/components/LoginScreen.tsx:80:41) (at http://localhost:3001/src/components/LoginScreen.tsx:86:14)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/6ed69686-05fe-419a-add5-5fd54bc300e8
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC002 Failed login with invalid credentials
- **Test Code:** [TC002_Failed_login_with_invalid_credentials.py](./TC002_Failed_login_with_invalid_credentials.py)
- **Test Error:** Tested login with invalid credentials. The login attempt failed to show any error message or notification indicating invalid credentials. This is a failure of the expected behavior for login failure feedback.
Browser Console Logs:
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/token?grant_type=password:0:0)
[ERROR] Auth Error: AuthApiError: Invalid login credentials
    at handleError2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4255:9)
    at async _handleRequest2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4296:5)
    at async _request (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4280:16)
    at async SupabaseAuthClient.signInWithPassword (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:5024:15)
    at async handleEmailAuth (http://localhost:3001/src/components/LoginScreen.tsx:80:41) (at http://localhost:3001/src/components/LoginScreen.tsx:86:14)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/c79f4a53-2d23-4662-9e89-86ab3f0ef782
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC003 Custom auto-login on specialized domains
- **Test Code:** [TC003_Custom_auto_login_on_specialized_domains.py](./TC003_Custom_auto_login_on_specialized_domains.py)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/3c4cef9c-393c-43e0-9a58-3478dfb0b425
- **Status:** ✅ Passed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC004 Admin Panel: Add new school
- **Test Code:** [TC004_Admin_Panel_Add_new_school.py](./TC004_Admin_Panel_Add_new_school.py)
- **Test Error:** Unable to proceed with adding a new school because valid administrator login credentials are not available. Login attempts with provided credentials failed, and alternative login methods are disabled. Please provide valid admin credentials to continue the task.
Browser Console Logs:
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/token?grant_type=password:0:0)
[ERROR] Auth Error: AuthApiError: Invalid login credentials
    at handleError2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4255:9)
    at async _handleRequest2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4296:5)
    at async _request (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4280:16)
    at async SupabaseAuthClient.signInWithPassword (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:5024:15)
    at async handleEmailAuth (http://localhost:3001/src/components/LoginScreen.tsx:80:41) (at http://localhost:3001/src/components/LoginScreen.tsx:86:14)
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/authorize?provider=google&redirect_to=http%3A%2F%2Flocalhost%3A3001:0:0)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/4457c1c5-6c24-4ed5-94e0-0ad37e2f03c4
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC005 Admin Panel: Edit existing user details
- **Test Code:** [TC005_Admin_Panel_Edit_existing_user_details.py](./TC005_Admin_Panel_Edit_existing_user_details.py)
- **Test Error:** Unable to proceed with the task as administrator login failed due to incorrect credentials and Google login is not enabled. Please provide valid administrator credentials to continue testing user detail updates.
Browser Console Logs:
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/token?grant_type=password:0:0)
[ERROR] Auth Error: AuthApiError: Invalid login credentials
    at handleError2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4255:9)
    at async _handleRequest2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4296:5)
    at async _request (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4280:16)
    at async SupabaseAuthClient.signInWithPassword (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:5024:15)
    at async handleEmailAuth (http://localhost:3001/src/components/LoginScreen.tsx:80:41) (at http://localhost:3001/src/components/LoginScreen.tsx:86:14)
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/authorize?provider=google&redirect_to=http%3A%2F%2Flocalhost%3A3001:0:0)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/871877ab-0725-4fa4-9cf3-ecf5ff9fcaa9
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC006 Admin Panel: Prevent invalid school creation
- **Test Code:** [TC006_Admin_Panel_Prevent_invalid_school_creation.py](./TC006_Admin_Panel_Prevent_invalid_school_creation.py)
- **Test Error:** Login attempt failed due to incorrect credentials. Please provide valid administrator login credentials to proceed with the task of verifying school creation validation errors.
Browser Console Logs:
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/token?grant_type=password:0:0)
[ERROR] Auth Error: AuthApiError: Invalid login credentials
    at handleError2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4255:9)
    at async _handleRequest2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4296:5)
    at async _request (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4280:16)
    at async SupabaseAuthClient.signInWithPassword (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:5024:15)
    at async handleEmailAuth (http://localhost:3001/src/components/LoginScreen.tsx:80:41) (at http://localhost:3001/src/components/LoginScreen.tsx:86:14)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/577eed89-592e-42c9-9c2f-5b0923c8a420
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC007 School data integration: Add and retrieve school info
- **Test Code:** [TC007_School_data_integration_Add_and_retrieve_school_info.py](./TC007_School_data_integration_Add_and_retrieve_school_info.py)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/1d3ff075-3583-4bec-818f-9263a2cf4234
- **Status:** ✅ Passed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC008 PDI: Create Individual Development Plan successfully
- **Test Code:** [TC008_PDI_Create_Individual_Development_Plan_successfully.py](./TC008_PDI_Create_Individual_Development_Plan_successfully.py)
- **Test Error:** The task to verify that users can create a new Individual Development Plan (PDI) for a student with complete and valid data could not be fully completed. Although login and navigation to the PDI management module were successful, the dropdowns for selecting 'Aula Base' and 'Turma Alvo' only showed default placeholder options with no valid selections available. No further UI elements or forms appeared to allow creation of a new PDI. Therefore, the creation and submission of a new PDI could not be tested or verified.
Browser Console Logs:
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/token?grant_type=password:0:0)
[ERROR] Auth Error: AuthApiError: Invalid login credentials
    at handleError2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4255:9)
    at async _handleRequest2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4296:5)
    at async _request (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4280:16)
    at async SupabaseAuthClient.signInWithPassword (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:5024:15)
    at async handleEmailAuth (http://localhost:3001/src/components/LoginScreen.tsx:80:41) (at http://localhost:3001/src/components/LoginScreen.tsx:86:14)
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/authorize?provider=google&redirect_to=http%3A%2F%2Flocalhost%3A3001:0:0)
[ERROR] Failed to load resource: the server responded with a status of 406 () (at https://pegirezfkihdnnqwqeaq.supabase.co/rest/v1/profiles?select=*%2Cschools%3Aschool_id%28name%29&id=eq.f42c5ea2-1570-4925-888c-cbbe5b982edf:0:0)
[ERROR] Error fetching user profile: {code: PGRST116, details: The result contains 0 rows, hint: null, message: Cannot coerce the result to a single JSON object} (at http://localhost:3001/src/services/userService.ts:14:12)
[ERROR] Failed to load resource: the server responded with a status of 406 () (at https://pegirezfkihdnnqwqeaq.supabase.co/rest/v1/referrals?select=*&referee_email=eq.newteacher%40example.com&status=eq.pending:0:0)
[ERROR] [DEBUG] Generic Fetch Error: {message: TypeError: Failed to fetch, details: TypeError: Failed to fetch
    at http://localhost…deps/@supabase_supabase-js.js?v=f4b35bf9:3758:24), hint: , code: } (at http://localhost:3001/src/features/TermPlanning/TermPlanningService.ts:80:14)
[ERROR] [DEBUG] Structured Fetch Error: {message: TypeError: Failed to fetch, details: TypeError: Failed to fetch
    at http://localhost…deps/@supabase_supabase-js.js?v=f4b35bf9:3758:24), hint: , code: } (at http://localhost:3001/src/features/TermPlanning/TermPlanningService.ts:55:14)
[ERROR] [DEBUG] Structured Fetch Error: {message: TypeError: Failed to fetch, details: TypeError: Failed to fetch
    at http://localhost…deps/@supabase_supabase-js.js?v=f4b35bf9:3758:24), hint: , code: } (at http://localhost:3001/src/features/TermPlanning/TermPlanningService.ts:55:14)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/296c9685-e6bd-4ea4-a53b-afb1a9402cf2
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC009 PDI: Update existing Individual Development Plan
- **Test Code:** [TC009_PDI_Update_existing_Individual_Development_Plan.py](./TC009_PDI_Update_existing_Individual_Development_Plan.py)
- **Test Error:** The task to verify users can update information of an existing PDI and save changes correctly could not be fully completed due to lack of valid login credentials for both gestor and professor roles. Multiple login attempts failed with error messages indicating incorrect credentials. Alternative login methods like Google are disabled. No password reset or recovery options were found. Therefore, it was not possible to access existing PDIs to perform updates and verify persistence of changes. Task is incomplete.
Browser Console Logs:
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/token?grant_type=password:0:0)
[ERROR] Auth Error: AuthApiError: Invalid login credentials
    at handleError2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4255:9)
    at async _handleRequest2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4296:5)
    at async _request (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4280:16)
    at async SupabaseAuthClient.signInWithPassword (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:5024:15)
    at async handleEmailAuth (http://localhost:3001/src/components/LoginScreen.tsx:80:41) (at http://localhost:3001/src/components/LoginScreen.tsx:86:14)
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/authorize?provider=google&redirect_to=http%3A%2F%2Flocalhost%3A3001:0:0)
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/token?grant_type=password:0:0)
[ERROR] Auth Error: AuthApiError: Invalid login credentials
    at handleError2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4255:9)
    at async _handleRequest2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4296:5)
    at async _request (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4280:16)
    at async SupabaseAuthClient.signInWithPassword (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:5024:15)
    at async handleEmailAuth (http://localhost:3001/src/components/LoginScreen.tsx:80:41) (at http://localhost:3001/src/components/LoginScreen.tsx:86:14)
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/token?grant_type=password:0:0)
[ERROR] Auth Error: AuthApiError: Invalid login credentials
    at handleError2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4255:9)
    at async _handleRequest2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4296:5)
    at async _request (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4280:16)
    at async SupabaseAuthClient.signInWithPassword (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:5024:15)
    at async handleEmailAuth (http://localhost:3001/src/components/LoginScreen.tsx:80:41) (at http://localhost:3001/src/components/LoginScreen.tsx:86:14)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/655d093f-b45f-4e1c-9985-6a07fc405f2f
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC010 PDI: Delete an Individual Development Plan
- **Test Code:** [TC010_PDI_Delete_an_Individual_Development_Plan.py](./TC010_PDI_Delete_an_Individual_Development_Plan.py)
- **Test Error:** The task to verify deletion of an Individual Development Plan could not be completed because the login attempt failed due to incorrect credentials. Without access to the professor workspace, it was not possible to access, delete, or verify the removal of any PDI. The login failure issue has been reported.
Browser Console Logs:
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/token?grant_type=password:0:0)
[ERROR] Auth Error: AuthApiError: Invalid login credentials
    at handleError2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4255:9)
    at async _handleRequest2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4296:5)
    at async _request (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4280:16)
    at async SupabaseAuthClient.signInWithPassword (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:5024:15)
    at async handleEmailAuth (http://localhost:3001/src/components/LoginScreen.tsx:80:41) (at http://localhost:3001/src/components/LoginScreen.tsx:86:14)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/f61bbb84-82b3-49d0-bbce-b223bb96b9a4
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC011 Planning Module: Create a new lesson plan
- **Test Code:** [TC011_Planning_Module_Create_a_new_lesson_plan.py](./TC011_Planning_Module_Create_a_new_lesson_plan.py)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/f6165ad8-0f1f-4e3b-ae52-81ea5e950599
- **Status:** ✅ Passed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC012 Planning Module: Adjust and update an existing lesson plan
- **Test Code:** [TC012_Planning_Module_Adjust_and_update_an_existing_lesson_plan.py](./TC012_Planning_Module_Adjust_and_update_an_existing_lesson_plan.py)
- **Test Error:** Login attempts to access the teacher's workspace repeatedly redirect to account creation or show errors for unsupported providers. This prevents accessing lesson plans to verify updates. The login flow appears broken or misconfigured. Reporting this critical issue and stopping further testing.
Browser Console Logs:
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/token?grant_type=password:0:0)
[ERROR] Auth Error: AuthApiError: Invalid login credentials
    at handleError2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4255:9)
    at async _handleRequest2 (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4296:5)
    at async _request (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:4280:16)
    at async SupabaseAuthClient.signInWithPassword (http://localhost:3001/node_modules/.vite/deps/@supabase_supabase-js.js?v=f4b35bf9:5024:15)
    at async handleEmailAuth (http://localhost:3001/src/components/LoginScreen.tsx:80:41) (at http://localhost:3001/src/components/LoginScreen.tsx:86:14)
[ERROR] Failed to load resource: the server responded with a status of 400 () (at https://pegirezfkihdnnqwqeaq.supabase.co/auth/v1/authorize?provider=google&redirect_to=http%3A%2F%2Flocalhost%3A3001:0:0)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/04417503-b8e4-46a0-86ff-c67680b35593
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC013 Planning Module: Simulate curriculum scenarios successfully
- **Test Code:** [TC013_Planning_Module_Simulate_curriculum_scenarios_successfully.py](./TC013_Planning_Module_Simulate_curriculum_scenarios_successfully.py)
- **Test Error:** Simulation Workspace module is not accessible or visible after navigating to 'Funcionalidades'. Unable to proceed with simulation testing as the required module is missing. Task cannot be completed.
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/e2755d4c-074a-45e7-ac5f-403fc52c529f
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC014 Planning Module: Handle invalid lesson plan inputs
- **Test Code:** [TC014_Planning_Module_Handle_invalid_lesson_plan_inputs.py](./TC014_Planning_Module_Handle_invalid_lesson_plan_inputs.py)
- **Test Error:** Stopped testing due to critical issue: Unable to create account and access lesson plan creation form. Validation or backend issue blocks account creation form submission despite valid inputs. Cannot proceed with validation tests on lesson plan creation. Please fix this issue to enable further testing.
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/786fc5d0-c0e6-4852-9428-8dbee181798d/dd941118-f40f-4930-a35a-f4f6fef01396
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---


## 3️⃣ Coverage & Matching Metrics

- **21.43** of tests passed

| Requirement        | Total Tests | ✅ Passed | ❌ Failed  |
|--------------------|-------------|-----------|------------|
| ...                | ...         | ...       | ...        |
---


## 4️⃣ Key Gaps / Risks
{AI_GNERATED_KET_GAPS_AND_RISKS}
---