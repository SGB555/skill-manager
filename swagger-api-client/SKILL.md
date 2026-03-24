---
name: swagger-api-client
description: Generate TypeScript API client code from Swagger/OpenAPI documentation. Use when the user provides a Swagger URL, asks to generate API calls, or needs to create API client code from an OpenAPI spec.
---

# Swagger API Client Generator

Generate type-safe API client code from Swagger/OpenAPI documentation.

## When to Use

- User provides a Swagger/OpenAPI URL (e.g., `http://localhost:3000/api/`)
- User asks to generate API client code
- User wants to create API functions from an API spec

## Workflow

### Step 1: Read the API Documentation

Use `browser_navigate` and `browser_snapshot` MCP tools to read the Swagger UI:

```
1. Navigate to the Swagger URL
2. Take a snapshot to see available endpoints
3. Click on each endpoint to expand details
4. Capture request/response schemas
```

### Step 2: Analyze Existing Project Code

Before generating code, check the project's existing patterns:

```
Search for:
- src/api/ or api/ directories
- Existing HTTP client usage (fetch, axios, ky)
- Existing type definitions
- React Query or SWR usage
```

Match the existing code style and conventions.

### Step 3: Generate TypeScript Types

Create types based on Swagger schemas:

```typescript
// Types from Swagger schemas
export interface LoginDto {
  email: string;
  password: string;
}

export interface User {
  id: string;
  email: string;
  name: string;
}

// API Response wrapper (if used in project)
export interface ApiResponse<T> {
  data: T;
  message?: string;
}
```

### Step 4: Generate API Client Functions

Follow project's existing HTTP client pattern:

**If using fetch:**
```typescript
export async function login(dto: LoginDto): Promise<User> {
  const response = await fetch(`${API_BASE_URL}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(dto),
  });
  if (!response.ok) throw new Error('Login failed');
  return response.json();
}
```

**If using axios:**
```typescript
export async function login(dto: LoginDto): Promise<User> {
  const { data } = await api.post<User>('/auth/login', dto);
  return data;
}
```

### Step 5: Add Authentication Handling

For protected endpoints, include auth headers:

```typescript
// Get token from storage/context
const getAuthHeaders = () => ({
  Authorization: `Bearer ${getToken()}`,
});

export async function getMe(): Promise<User> {
  const response = await fetch(`${API_BASE_URL}/user/me`, {
    headers: getAuthHeaders(),
  });
  return response.json();
}
```

### Step 6: Generate React Query Hooks (Optional)

If project uses React Query:

```typescript
import { useQuery, useMutation } from '@tanstack/react-query';

export function useMe() {
  return useQuery({
    queryKey: ['user', 'me'],
    queryFn: getMe,
  });
}

export function useLogin() {
  return useMutation({
    mutationFn: login,
  });
}
```

## Error Handling Pattern

```typescript
export class ApiError extends Error {
  constructor(
    public status: number,
    public message: string,
    public details?: unknown
  ) {
    super(message);
  }
}

async function handleResponse<T>(response: Response): Promise<T> {
  if (!response.ok) {
    const error = await response.json().catch(() => ({}));
    throw new ApiError(
      response.status,
      error.message || 'Request failed',
      error
    );
  }
  return response.json();
}
```

## File Organization

Typical structure:

```
src/api/
├── client.ts       # Base HTTP client setup
├── types.ts        # Shared TypeScript types
├── auth.ts         # Auth endpoints
├── user.ts         # User endpoints
├── [resource].ts   # Other resource endpoints
└── hooks/          # React Query hooks (optional)
    ├── useAuth.ts
    └── useUser.ts
```

## Checklist

- [ ] Read Swagger documentation completely
- [ ] Analyze existing project code patterns
- [ ] Generate TypeScript types from schemas
- [ ] Generate API functions matching project style
- [ ] Add authentication for protected endpoints
- [ ] Add error handling
- [ ] Generate hooks if React Query/SWR is used
- [ ] Place files in appropriate directories
