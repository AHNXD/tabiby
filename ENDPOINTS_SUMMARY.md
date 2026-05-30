# Tabiby API Endpoints Summary

**Base URL:** `http://192.168.1.3:8000/api`

This document provides a comprehensive overview of all endpoints used in the Tabiby Flutter app, organized by feature with request/response examples.

---

## Authentication Endpoints

### 1. Login
**Endpoint:** `POST /login`

**Purpose:** Authenticate user with phone and password, retrieve auth token.

**Request Body:**
```json
{
  "phone": "201001234567",
  "password": "password123",
  "fcm_token": "firebase_cloud_messaging_token"
}
```

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "user": {
      "main_data": {
        "token": "auth_token_string",
        "role": "patient"
      }
    }
  }
}
```

**Used in:** `lib/features/auth/data/repos/login_repo/login_repo_ipml.dart`
**Repository Method:** `LoginRepo.login(String phone, String password) -> Either<Failure, String>`

---

### 2. Register
**Endpoint:** `POST /register`

**Purpose:** Create new user account with credentials.

**Request Body:**
```json
{
  "phone": "201001234567",
  "password": "password123",
  "password_confirmation": "password123",
  "fcm_token": "firebase_cloud_messaging_token"
}
```

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "user": {
      "main_data": {
        "token": "auth_token_string",
        "role": "patient"
      }
    }
  }
}
```

**Used in:** `lib/features/auth/data/repos/register_repo/`

---

### 3. Logout
**Endpoint:** `POST /logout`

**Purpose:** Invalidate user session and auth token.

**Headers Required:**
- `Authorization: Bearer <token>`

**Response (Success - 200):**
```json
{
  "status": true,
  "message": "Logged out successfully"
}
```

**Used in:** `lib/features/auth/data/repos/logout_repo/`

---

### 4. Forget Password
**Endpoint:** `POST /password/forget_password`

**Purpose:** Request password reset, receive OTP via email/SMS.

**Request Body:**
```json
{
  "phone": "201001234567"
}
```

**Response (Success - 200):**
```json
{
  "status": true,
  "message": "OTP sent to registered email"
}
```

**Used in:** `lib/features/auth/data/repos/reset_password_repo/`

---

### 5. Reset Password with OTP
**Endpoint:** `POST /password/reset_password?otp={otp}&password={password}`

**Purpose:** Reset password using received OTP.

**Query Parameters:**
- `otp` - One-time password sent to user
- `password` - New password

**Response (Success - 200):**
```json
{
  "status": true,
  "message": "Password reset successfully"
}
```

**Used in:** `lib/features/auth/data/repos/reset_password_repo/`

---

### 6. Reset Password After Auth
**Endpoint:** `POST /reset_password_after_auth?password={password}&password_confirmation={confirmation}`

**Purpose:** Reset password for authenticated user.

**Headers Required:**
- `Authorization: Bearer <token>`

**Query Parameters:**
- `password` - New password
- `password_confirmation` - Confirmation of new password

**Response (Success - 200):**
```json
{
  "status": true,
  "message": "Password updated successfully"
}
```

---

## User Profile Endpoints

### 1. Get Profile
**Endpoint:** `GET /get_profile`

**Purpose:** Retrieve authenticated user profile details.

**Headers Required:**
- `Authorization: Bearer <token>`

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "id": 1,
    "phone": "201001234567",
    "name": "Ahmed Hassan",
    "email": "user@example.com",
    "avatar": "https://...",
    "role": "patient"
  }
}
```

**Used in:** `lib/features/user_app/user/data/repos/user_repo_iplm.dart`

---

### 2. Update Profile
**Endpoint:** `POST /update_profile`

**Purpose:** Update user profile information.

**Headers Required:**
- `Authorization: Bearer <token>`
- `Content-Type: application/json`

**Request Body:**
```json
{
  "name": "Ahmed Hassan",
  "email": "user@example.com",
  "phone": "201001234567"
}
```

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "id": 1,
    "name": "Ahmed Hassan",
    "email": "user@example.com",
    "phone": "201001234567"
  }
}
```

**Used in:** `lib/features/user_app/user/data/repos/user_repo_iplm.dart`

---

### 3. Delete Account
**Endpoint:** `DELETE /delete_account`

**Purpose:** Permanently delete user account and data.

**Headers Required:**
- `Authorization: Bearer <token>`

**Response (Success - 200):**
```json
{
  "status": true,
  "message": "Account deleted successfully"
}
```

**Used in:** `lib/features/user_app/user/data/repos/user_repo_iplm.dart`

---

## Doctor Discovery Endpoints

### 1. Get All Specialties
**Endpoint:** `GET /get_all_specialties`

**Purpose:** Retrieve list of all medical specialties.

**Headers Required:**
- `Accept-Language: en` or `ar`

**Response (Success - 200):**
```json
{
  "status": true,
  "data": [
    {
      "id": 1,
      "name": "Cardiology",
      "icon": "https://...",
      "description": "Heart specialist"
    },
    {
      "id": 2,
      "name": "Neurology",
      "icon": "https://...",
      "description": "Nervous system specialist"
    }
  ]
}
```

**Used in:** `lib/features/user_app/specialties/data/repos/user_repo_iplm.dart`

---

### 2. Get All Doctors
**Endpoint:** `GET /get_all_doctors`

**Purpose:** Retrieve list of all available doctors with filters.

**Query Parameters:**
- `specialty_id` - Filter by specialty
- `search` - Search by name
- `page` - Pagination

**Response (Success - 200):**
```json
{
  "status": true,
  "data": [
    {
      "id": 1,
      "name": "Dr. Ahmed Hassan",
      "specialty": "Cardiology",
      "rate": 4.5,
      "image": "https://...",
      "experience_years": 10
    }
  ]
}
```

**Used in:** `lib/features/user_app/doctors/data/repos/doctors_repo_iplm.dart`

---

### 3. Get Doctor Details
**Endpoint:** `GET /get_doctor?id={doctorId}`

**Purpose:** Retrieve detailed information about specific doctor.

**Query Parameters:**
- `id` - Doctor ID

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "id": 1,
    "name": "Dr. Ahmed Hassan",
    "specialty": "Cardiology",
    "rate": 4.5,
    "image": "https://...",
    "experience_years": 10,
    "bio": "Expert in cardiac care",
    "centers": [
      {
        "id": 1,
        "name": "Medical Center",
        "location": "Cairo"
      }
    ]
  }
}
```

**Used in:** `lib/features/user_app/doctors/data/repos/doctors_repo_iplm.dart`

---

## Clinic Centers Endpoints

### 1. Get All Clinic Centers
**Endpoint:** `GET /get_all_clinic_centers`

**Purpose:** Retrieve list of all medical clinic centers.

**Response (Success - 200):**
```json
{
  "status": true,
  "data": [
    {
      "id": 1,
      "name": "Central Medical Center",
      "location": "Cairo",
      "address": "123 Main St",
      "phone": "0201012345678",
      "rate": 4.7,
      "image": "https://..."
    }
  ]
}
```

**Used in:** `lib/features/user_app/centers/data/repos/centers_repo_iplm.dart`

---

### 2. Get Clinic Center Details
**Endpoint:** `GET /get_clinic_center?id={centerId}`

**Purpose:** Retrieve detailed information about specific clinic center.

**Query Parameters:**
- `id` - Center ID

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "id": 1,
    "name": "Central Medical Center",
    "location": "Cairo",
    "address": "123 Main St",
    "phone": "0201012345678",
    "rate": 4.7,
    "image": "https://...",
    "doctors": [1, 2, 3],
    "services": ["Cardiology", "Neurology"]
  }
}
```

**Used in:** `lib/features/user_app/centers/data/repos/centers_repo_iplm.dart`

---

## Home Screen Endpoint

### 1. Get Home Data
**Endpoint:** `GET /home`

**Purpose:** Retrieve home screen data including featured doctors, specialties, and recommendations.

**Headers Required:**
- `Authorization: Bearer <token>`
- `Accept-Language: en` or `ar`

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "featured_doctors": [
      {
        "id": 1,
        "name": "Dr. Ahmed Hassan",
        "specialty": "Cardiology",
        "rate": 4.5,
        "image": "https://..."
      }
    ],
    "specialties": [
      {
        "id": 1,
        "name": "Cardiology",
        "icon": "https://..."
      }
    ],
    "centers": [
      {
        "id": 1,
        "name": "Central Medical Center",
        "image": "https://..."
      }
    ]
  }
}
```

**Used in:** `lib/features/user_app/home/data/repo/home_repo_iplm.dart`
**Repository Method:** `HomeRepo.getHome() -> Either<Failure, HomeModel>`

---

## Appointment Booking Endpoints

### 1. Get Doctor Centers
**Endpoint:** `GET /get_doctor_centers/{doctorId}`

**Purpose:** Retrieve list of centers where doctor works.

**Path Parameters:**
- `doctorId` - ID of doctor

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "centers": [
      {
        "id": 1,
        "name": "Central Medical Center",
        "location": "Cairo"
      }
    ]
  }
}
```

**Used in:** `lib/features/user_app/add_appointment/data/repos/add_appoinment_repo_iplm.dart`

---

### 2. Get Available Days (30 days)
**Endpoint:** `GET /get_30_days/{doctorId}/{centerId}`

**Purpose:** Retrieve next 30 available appointment days.

**Path Parameters:**
- `doctorId` - ID of doctor
- `centerId` - ID of clinic center

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "days": [
      {
        "date": "2024-06-15",
        "day_name": "Saturday",
        "available": true
      },
      {
        "date": "2024-06-16",
        "day_name": "Sunday",
        "available": false
      }
    ]
  }
}
```

**Used in:** `lib/features/user_app/add_appointment/data/repos/add_appoinment_repo_iplm.dart`

---

### 3. Get Available Times
**Endpoint:** `GET /get_times_today/{doctorId}/{centerId}/{date}`

**Purpose:** Retrieve available appointment time slots for specific date.

**Path Parameters:**
- `doctorId` - ID of doctor
- `centerId` - ID of clinic center
- `date` - Date in format YYYY-MM-DD

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "times": [
      {
        "period_name": "morning",
        "times": ["09:00", "09:30", "10:00", "10:30"]
      },
      {
        "period_name": "afternoon",
        "times": ["02:00", "02:30", "03:00"]
      }
    ]
  }
}
```

**Used in:** `lib/features/user_app/add_appointment/data/repos/add_appoinment_repo_iplm.dart`

---

### 4. Get Lab Tests
**Endpoint:** `GET /lab-tests?center_id={centerId}`

**Purpose:** Retrieve available lab tests for specific center.

**Query Parameters:**
- `center_id` - ID of clinic center

**Response (Success - 200):**
```json
{
  "status": true,
  "data": [
    {
      "id": 1,
      "name": "Blood Test",
      "code": "BT001",
      "description": "Complete blood count"
    },
    {
      "id": 2,
      "name": "X-Ray",
      "code": "XR001",
      "description": "Chest X-ray"
    }
  ]
}
```

**Used in:** `lib/features/user_app/add_appointment/data/repos/add_appoinment_repo_iplm.dart`

---

### 5. Get Medical Image Types
**Endpoint:** `GET /medical-image-types?center_id={centerId}`

**Purpose:** Retrieve available medical image types for appointment.

**Query Parameters:**
- `center_id` - ID of clinic center

**Response (Success - 200):**
```json
{
  "status": true,
  "data": [
    {
      "id": 1,
      "name": "Chest X-Ray",
      "code": "XR_CHEST"
    },
    {
      "id": 2,
      "name": "Ultrasound",
      "code": "US_ABDOMEN"
    }
  ]
}
```

**Used in:** `lib/features/user_app/add_appointment/data/repos/add_appoinment_repo_iplm.dart`

---

### 6. Book Appointment
**Endpoint:** `POST /appointment/{doctorId}/{centerId}/{date}/{periodName}`

**Purpose:** Create new appointment booking.

**Path Parameters:**
- `doctorId` - ID of doctor
- `centerId` - ID of clinic center
- `date` - Appointment date (YYYY-MM-DD)
- `periodName` - Period (morning/afternoon/evening)

**Headers Required:**
- `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "doctor_id": 1,
  "center_id": 1,
  "date": "2024-06-15",
  "period_name": "morning",
  "time": "09:30",
  "notes": "Have chest pain",
  "lab_tests": [1, 2],
  "medical_image_types": [1],
  "medical_attachments": ["file_ids"],
  "diagnosis_result": null
}
```

**Response (Success - 200-299):**
```json
{
  "status": true,
  "data": {
    "id": 123,
    "appointment_number": "APT-2024-001",
    "doctor_id": 1,
    "center_id": 1,
    "date": "2024-06-15",
    "time": "09:30",
    "status": "confirmed"
  }
}
```

**Used in:** `lib/features/user_app/add_appointment/data/repos/add_appoinment_repo_iplm.dart`

---

## Patient Appointments Endpoints

### 1. Get My Appointments
**Endpoint:** `GET /appointments`

**Purpose:** Retrieve list of authenticated patient's appointments.

**Headers Required:**
- `Authorization: Bearer <token>`

**Query Parameters:**
- `status` - Filter by status (upcoming/completed/cancelled)
- `page` - Pagination

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "appointments": [
      {
        "id": 123,
        "doctor_name": "Dr. Ahmed Hassan",
        "specialty": "Cardiology",
        "date": "2024-06-15",
        "time": "09:30",
        "center": "Central Medical Center",
        "status": "confirmed"
      }
    ]
  }
}
```

**Used in:** `lib/features/user_app/user_appointments/data/repos/my_appointments/my_appointments_repo_iplm.dart`

---

### 2. Cancel Appointment
**Endpoint:** `POST /appointments/cancel`

**Purpose:** Cancel existing appointment.

**Headers Required:**
- `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "appointment_id": 123,
  "reason": "Unable to attend"
}
```

**Response (Success - 200):**
```json
{
  "status": true,
  "message": "Appointment cancelled successfully"
}
```

**Used in:** `lib/features/user_app/user_appointments/data/repos/my_appointments/my_appointments_repo_iplm.dart`

---

### 3. Rate Appointment
**Endpoint:** `POST /patient/appointments/rate`

**Purpose:** Submit rating and review for completed appointment.

**Headers Required:**
- `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "appointment_id": 123,
  "rating": 5,
  "review": "Excellent doctor, very professional"
}
```

**Response (Success - 200):**
```json
{
  "status": true,
  "message": "Rating submitted successfully"
}
```

**Used in:** `lib/features/user_app/user_appointments/data/repos/rating/rating_repo_iplm.dart`

---

### 4. Check if Appointment Can Be Rated
**Endpoint:** `GET /patient/appointments/{appointmentId}/rating`

**Purpose:** Check if appointment is eligible for rating.

**Path Parameters:**
- `appointmentId` - ID of appointment

**Headers Required:**
- `Authorization: Bearer <token>`

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "can_rate": true,
    "already_rated": false
  }
}
```

---

## Doctor Appointments Endpoints

### 1. Get Doctor Appointments
**Endpoint:** `GET /doctor/appointments`

**Purpose:** Retrieve list of doctor's appointments (for doctor role).

**Headers Required:**
- `Authorization: Bearer <token>` (doctor token)

**Query Parameters:**
- `status` - Filter by status (pending/completed/cancelled)
- `date` - Filter by specific date
- `page` - Pagination

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "appointments": [
      {
        "id": 123,
        "patient_name": "Ahmed Hassan",
        "appointment_number": "APT-2024-001",
        "date": "2024-06-15",
        "time": "09:30",
        "center": "Central Medical Center",
        "status": "pending"
      }
    ]
  }
}
```

**Used in:** `lib/features/doctor_app/doctor_appointment/data/repos/doctor_appointments_repo_iplm.dart`

---

### 2. Get Appointment Details (Doctor)
**Endpoint:** `GET /appointment_details?appointment_id={appointmentId}`

**Purpose:** Retrieve detailed information about specific appointment (doctor view).

**Headers Required:**
- `Authorization: Bearer <token>` (doctor token)

**Query Parameters:**
- `appointment_id` - ID of appointment

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "id": 123,
    "patient_name": "Ahmed Hassan",
    "patient_phone": "201001234567",
    "appointment_number": "APT-2024-001",
    "date": "2024-06-15",
    "time": "09:30",
    "center": "Central Medical Center",
    "notes": "Have chest pain",
    "lab_tests": [
      {
        "id": 1,
        "name": "Blood Test"
      }
    ],
    "medical_attachments": [],
    "status": "pending"
  }
}
```

**Used in:** `lib/features/doctor_app/doctor_appointment_datails/data/repos/doctor_appointments_details_repo_iplm.dart`

---

### 3. End Appointment (Doctor)
**Endpoint:** `POST /doctor/appointments/end`

**Purpose:** Mark appointment as completed by doctor.

**Headers Required:**
- `Authorization: Bearer <token>` (doctor token)

**Request Body:**
```json
{
  "appointment_id": 123,
  "diagnosis": "Diagnosed with hypertension",
  "prescription": "Aspirin 500mg daily"
}
```

**Response (Success - 200):**
```json
{
  "status": true,
  "message": "Appointment completed successfully"
}
```

---

## Medical Files Endpoints

### 1. Upload Medical Record
**Endpoint:** `POST /patient/medical_record/stroe`

**Purpose:** Upload patient medical file (note: endpoint has typo "stroe").

**Headers Required:**
- `Authorization: Bearer <token>`
- `Content-Type: multipart/form-data`

**Request Body (FormData):**
```
file: <binary_file_data>
file_type: "prescription" | "lab_result" | "medical_image" | "other"
title: "Blood Test Results"
description: "Complete blood count test"
```

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "id": 456,
    "file_name": "blood_test.pdf",
    "file_type": "lab_result",
    "title": "Blood Test Results",
    "url": "https://..."
  }
}
```

**Used in:** `lib/features/user_app/medical_files/data/repos/medical_files_repo_iplm.dart`

---

### 2. Get Patient Medical Records
**Endpoint:** `GET /patient/medical-records`

**Purpose:** Retrieve list of patient's uploaded medical files.

**Headers Required:**
- `Authorization: Bearer <token>`

**Query Parameters:**
- `page` - Pagination
- `limit` - Records per page

**Response (Success - 200):**
```json
{
  "status": true,
  "data": [
    {
      "id": 456,
      "file_name": "blood_test.pdf",
      "file_type": "lab_result",
      "title": "Blood Test Results",
      "url": "https://...",
      "created_at": "2024-06-10"
    }
  ]
}
```

**Used in:** `lib/features/user_app/medical_files/data/repos/medical_files_repo_iplm.dart`

---

## AI Diagnosis Endpoints

### 1. Get Symptoms
**Endpoint:** `POST /ai/get-symptoms`

**Purpose:** Retrieve symptoms for body part from AI proxy.

**Headers Required:**
- `Authorization: Bearer <token>`
- `Accept-Language: en` or `ar`

**Request Body:**
```json
{
  "body_part": "chest"
}
```

**Response (Success - 200):**
```json
{
  "symptoms": [
    {
      "id": "chest_pain",
      "name": "Chest Pain",
      "description": "Sharp or dull pain in chest area"
    },
    {
      "id": "shortness_breath",
      "name": "Shortness of Breath",
      "description": "Difficulty breathing or catching breath"
    }
  ]
}
```

**Used in:** `lib/features/user_app/diagnose/data/repos/diagnosis_repository_iplm.dart`
**Repository Method:** `DiagnosisRepository.getSymptoms(String bodyPart) -> Either<Failure, List<Symptom>>`

---

### 2. Post Diagnosis (Symptom Analysis)
**Endpoint:** `POST /ai/diagnose`

**Purpose:** Submit symptoms and get AI diagnosis suggestions.

**Headers Required:**
- `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "body_part": "chest",
  "symptoms": [
    "chest_pain",
    "shortness_breath"
  ],
  "symptom_duration": "2 days",
  "additional_info": "Started after heavy exercise"
}
```

**Response (Success - 200):**
```json
{
  "triage_result": {
    "urgency": "high",
    "emergency_warning": ["Seek immediate medical attention if chest pain increases"],
    "primary_condition_suspicion": "Acute Coronary Syndrome",
    "differential_diagnoses": [
      "Myocardial infarction",
      "Unstable angina",
      "Pericarditis"
    ],
    "recommended_actions": "Consult cardiologist"
  }
}
```

**Used in:** `lib/features/user_app/diagnose/data/repos/diagnosis_repository_iplm.dart`
**Repository Method:** `DiagnosisRepository.postDiagnosis(DiagnosisRequest request) -> Either<Failure, DiagnosisResult>`

---

### 3. Analyze Chest X-Ray
**Endpoint:** `POST /ai/analyze-xray`

**Purpose:** Analyze uploaded chest X-ray image using AI.

**Headers Required:**
- `Authorization: Bearer <token>`

**Request Body (FormData or JSON):**
```json
{
  "image": "base64_encoded_image_data",
  "file_name": "xray_2024.jpg"
}
```

**Response (Success - 200):**
```json
{
  "data": {
    "top_3_diseases": [
      {
        "disease": "Pneumonia",
        "confidence": "85%",
        "description": "Infection in lungs"
      },
      {
        "disease": "Bronchitis",
        "confidence": "70%",
        "description": "Inflammation of airways"
      }
    ],
    "findings": "Consolidation visible in right lower lobe",
    "recommendations": "Consult pulmonologist",
    "heatmap_url": "https://..."
  }
}
```

**Used in:** `lib/features/user_app/diagnose/data/repos/diagnosis_repository_iplm.dart`
**Repository Method:** `DiagnosisRepository.analyzeChestXray(String imagePath) -> Either<Failure, XrayDiagnosisResult>`

---

## AI Diet Plan Endpoints

### 1. Generate Diet Plan
**Endpoint:** `POST /ai/generate-diet-plan`

**Purpose:** Generate AI-based personalized diet plan.

**Headers Required:**
- `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "age": 35,
  "gender": "male",
  "weight": 75,
  "height": 180,
  "activity_level": "moderate",
  "dietary_preferences": ["vegetarian"],
  "health_conditions": ["diabetes"],
  "allergies": ["nuts"],
  "meals_per_day": 3,
  "language": "en"
}
```

**Response (Success - 200):**
```json
{
  "week_plan": {
    "Monday": {
      "breakfast": "Oatmeal with berries",
      "lunch": "Grilled chicken with vegetables",
      "dinner": "Fish with brown rice"
    },
    "Tuesday": {
      "breakfast": "Yogurt with granola",
      "lunch": "Turkey sandwich",
      "dinner": "Tofu stir-fry"
    }
  },
  "nutritional_info": {
    "calories": 2000,
    "protein": "120g",
    "carbs": "200g",
    "fat": "65g"
  },
  "tips": [
    "Stay hydrated with 2-3 liters of water daily",
    "Avoid fried foods"
  ]
}
```

**Used in:** `lib/features/user_app/diet/data/repos/diet_repository_iplm.dart`
**Repository Method:** `DietRepository.generateDietPlan(DietRequestData request) -> Either<Failure, DietPlanHistoryItem>`

---

### 2. Save Diet Plan
**Endpoint:** `POST /nutrition-plans`

**Purpose:** Save generated diet plan to user's history.

**Headers Required:**
- `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "request": {
    "age": 35,
    "gender": "male",
    "weight": 75,
    "height": 180,
    "activity_level": "moderate",
    "dietary_preferences": ["vegetarian"],
    "health_conditions": ["diabetes"],
    "allergies": ["nuts"],
    "meals_per_day": 3,
    "language": "en"
  },
  "plan": {
    "week_plan": {...},
    "nutritional_info": {...},
    "tips": [...]
  }
}
```

**Response (Success - 201):**
```json
{
  "status": true,
  "data": {
    "item": {
      "id": "plan_123",
      "created_at": "2024-06-15T10:30:00Z",
      "nutritional_info": {...}
    }
  }
}
```

---

### 3. Get Diet Plans (Paginated)
**Endpoint:** `GET /nutrition-plans?page={page}&limit={limit}`

**Purpose:** Retrieve paginated list of user's diet plan history.

**Headers Required:**
- `Authorization: Bearer <token>`

**Query Parameters:**
- `page` - Page number (default: 1)
- `limit` - Records per page (default: 10)

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "plans": [
      {
        "id": "plan_123",
        "created_at": "2024-06-15T10:30:00Z",
        "nutritional_info": {
          "calories": 2000,
          "protein": "120g"
        }
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 45
    }
  }
}
```

**Used in:** `lib/features/user_app/diet/data/repos/diet_repository_iplm.dart`
**Repository Method:** `DietRepository.getDietPlans(int page, int limit) -> Either<Failure, PaginatedDietPlansResult>`

---

### 4. Get Latest Diet Plan
**Endpoint:** `GET /nutrition-plans/latest`

**Purpose:** Retrieve user's most recent diet plan.

**Headers Required:**
- `Authorization: Bearer <token>`

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "id": "plan_123",
    "created_at": "2024-06-15T10:30:00Z",
    "week_plan": {...},
    "nutritional_info": {...}
  }
}
```

**Used in:** `lib/features/user_app/diet/data/repos/diet_repository_iplm.dart`
**Repository Method:** `DietRepository.getLatestDietPlan() -> Either<Failure, DietPlanHistoryItem>`

---

### 5. Get Diet Plan by ID
**Endpoint:** `GET /nutrition-plans/{planId}`

**Purpose:** Retrieve specific diet plan details.

**Path Parameters:**
- `planId` - ID of diet plan

**Headers Required:**
- `Authorization: Bearer <token>`

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "id": "plan_123",
    "created_at": "2024-06-15T10:30:00Z",
    "week_plan": {...},
    "nutritional_info": {...},
    "tips": [...]
  }
}
```

**Used in:** `lib/features/user_app/diet/data/repos/diet_repository_iplm.dart`
**Repository Method:** `DietRepository.getDietPlanById(String id) -> Either<Failure, DietPlanHistoryItem>`

---

## Notifications Endpoints

### 1. Get Notifications
**Endpoint:** `GET /notifications`

**Purpose:** Retrieve user's notification history.

**Headers Required:**
- `Authorization: Bearer <token>`

**Query Parameters:**
- `page` - Pagination
- `limit` - Items per page

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "notifications": [
      {
        "id": "notif_123",
        "title": "Appointment Reminder",
        "body": "Your appointment with Dr. Ahmed is in 1 hour",
        "type": "appointment",
        "read": false,
        "created_at": "2024-06-15T09:00:00Z"
      }
    ]
  }
}
```

**Used in:** `lib/features/user_app/notification_history/data/repos/notification_history_repo_iplm.dart`

---

### 2. Mark Notification as Read
**Endpoint:** `POST /notifications/{notificationId}/read`

**Purpose:** Mark specific notification as read.

**Path Parameters:**
- `notificationId` - ID of notification

**Headers Required:**
- `Authorization: Bearer <token>`

**Response (Success - 200):**
```json
{
  "status": true,
  "message": "Notification marked as read"
}
```

---

### 3. Update FCM Token
**Endpoint:** `POST /fcm-token`

**Purpose:** Update Firebase Cloud Messaging token for push notifications.

**Headers Required:**
- `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "fcm_token": "firebase_device_token_string"
}
```

**Response (Success - 200):**
```json
{
  "status": true,
  "message": "FCM token updated successfully"
}
```

---

## AI Usage Endpoints

### 1. Get Remaining AI Usage
**Endpoint:** `GET /ai/remaining`

**Purpose:** Check user's remaining AI service usage quota.

**Headers Required:**
- `Authorization: Bearer <token>`

**Response (Success - 200):**
```json
{
  "status": true,
  "data": {
    "diagnosis_remaining": 5,
    "diet_plans_remaining": 3,
    "xray_analysis_remaining": 2,
    "total_monthly_limit": 10
  }
}
```

**Used in:** `lib/core/repos/` (AI usage repository)

---

## Error Handling

All endpoints follow standard error response format:

**Error Response (4xx, 5xx):**
```json
{
  "status": false,
  "message": "Error description",
  "code": "ERROR_CODE"
}
```

**Common HTTP Status Codes:**
- `200-299` - Success
- `400` - Bad Request (invalid parameters)
- `401` - Unauthorized (missing/invalid token)
- `403` - Forbidden (access denied)
- `404` - Not Found (resource not found)
- `422` - Unprocessable Entity (validation error)
- `500` - Internal Server Error

**Error Handling Location:**
- `lib/core/errors/error_handler.dart` - Handles all errors
- `lib/core/errors/failuer.dart` - Failure models
- All repositories use `Either<Failure, T>` for error handling

---

## Request/Response Headers

**Standard Request Headers (Added by ApiServices):**
```
Accept: application/json
Accept-Charset: application/json
Accept-Language: en (or ar based on user locale)
Authorization: Bearer <token> (if authenticated)
Content-Type: application/json (except for FormData)
```

**Response Headers:**
- `Content-Type: application/json`
- Standard HTTP headers

---

## Authentication Flow

1. **Login** → Get token
2. Store token in `CacheHelper` with key `'token'`
3. All subsequent requests include `Authorization: Bearer <token>` header
4. **Unauthorized (401)** → `AuthInterceptor` redirects to login
5. **Logout** → Clear token, redirect to login

---

## Localization

APIs respond with localized content based on `Accept-Language` header:
- Request header: `Accept-Language: en` → English responses
- Request header: `Accept-Language: ar` → Arabic responses

---

## API Service Architecture

```
View (Screen)
    ↓ calls Cubit method
Cubit (State Management)
    ↓ calls Repository
Repository (Data Layer)
    ↓ calls ApiServices with Urls endpoint
ApiServices (HTTP Client - Dio wrapper)
    ↓ adds headers, interceptors, auth
Backend API
```

**Key Files:**
- `lib/core/Api_services/api_services.dart` - HTTP client wrapper
- `lib/core/Api_services/urls.dart` - All endpoint constants
- `lib/core/Api_services/auth_interceptor.dart` - Auth handling
- `lib/core/errors/error_handler.dart` - Error parsing
- `lib/core/utils/services_locater.dart` - Dependency injection

---

## Usage Example

```dart
// In Repository
Future<Either<Failure, AppointmentBookingResponse>> bookAppointment(
  AppointmentBookingRequest request,
) async {
  try {
    final resp = await _apiServices.post(
      endPoint: '${Urls.addAppointment}/${request.doctorId}/${request.centerId}/${request.date}/${request.periodName}',
      data: request.toJson(),
    );
    
    if (resp.statusCode == 200 && resp.data['status']) {
      return right(AppointmentBookingResponse.fromJson(resp.data));
    }
    
    return left(ServerFailure(resp.data['message'] ?? 'Error'));
  } catch (error) {
    return left(ErrorHandler.handle(error));
  }
}

// In Cubit
Future<void> bookAppointment(AppointmentBookingRequest request) async {
  emit(state.copyWith(status: BookingStatus.loading));
  
  final result = await _repository.bookAppointment(request);
  
  result.fold(
    (failure) => emit(state.copyWith(
      status: BookingStatus.error,
      message: failure.message,
    )),
    (success) => emit(state.copyWith(
      status: BookingStatus.success,
      appointment: success,
    )),
  );
}

// In Screen
BlocBuilder<BookingCubit, BookingState>(
  builder: (context, state) {
    if (state.status == BookingStatus.loading) {
      return LoadingWidget();
    }
    
    if (state.status == BookingStatus.error) {
      return ErrorWidget(message: state.message);
    }
    
    return SuccessWidget();
  },
)
```

---

## Notes for Senior Engineers

- All endpoints are centralized in `Urls` class
- Error handling is standardized through `ErrorHandler`
- All IO operations return `Either<Failure, T>`
- AuthInterceptor handles token management automatically
- Localization headers are added automatically
- FormData (multipart) is detected and headers adjusted automatically
- Use repository pattern, do not call `ApiServices` directly from screens
- Follow feature-first architecture
- Match existing patterns in target feature

