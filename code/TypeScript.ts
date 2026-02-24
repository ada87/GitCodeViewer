import express, { Request, Response, NextFunction } from 'express'

// ============ Types ============

interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
  timestamp: number
}

interface User {
  id: string
  name: string
  email: string
  role: 'admin' | 'editor' | 'viewer'
  createdAt: Date
  metadata: Record<string, unknown>
}

interface PaginationParams {
  page: number
  limit: number
  sortBy?: keyof User
  order?: 'asc' | 'desc'
}

// ============ Repository ============

class UserRepository {
  private users = new Map<string, User>()

  async findAll(params: PaginationParams): Promise<{ items: User[]; total: number }> {
    const all = Array.from(this.users.values())
    const sorted = params.sortBy
      ? all.sort((a, b) => {
          const va = String(a[params.sortBy!])
          const vb = String(b[params.sortBy!])
          return params.order === 'desc' ? vb.localeCompare(va) : va.localeCompare(vb)
        })
      : all
    const start = (params.page - 1) * params.limit
    return { items: sorted.slice(start, start + params.limit), total: all.length }
  }

  async findById(id: string): Promise<User | undefined> {
    return this.users.get(id)
  }

  async create(data: Omit<User, 'id' | 'createdAt'>): Promise<User> {
    const user: User = {
      ...data,
      id: crypto.randomUUID(),
      createdAt: new Date(),
    }
    this.users.set(user.id, user)
    return user
  }

  async update(id: string, data: Partial<User>): Promise<User | undefined> {
    const existing = this.users.get(id)
    if (!existing) return undefined
    const updated = { ...existing, ...data }
    this.users.set(id, updated)
    return updated
  }

  async delete(id: string): Promise<boolean> {
    return this.users.delete(id)
  }
}

// ============ Middleware ============

function asyncHandler(fn: (req: Request, res: Response, next: NextFunction) => Promise<void>) {
  return (req: Request, res: Response, next: NextFunction) => {
    fn(req, res, next).catch(next)
  }
}

function respond<T>(res: Response, data: T, status = 200) {
  const body: ApiResponse<T> = { success: true, data, timestamp: Date.now() }
  res.status(status).json(body)
}

// ============ Routes ============

const app = express()
const repo = new UserRepository()

app.use(express.json())

app.get('/api/users', asyncHandler(async (req, res) => {
  const page = Number(req.query.page) || 1
  const limit = Math.min(Number(req.query.limit) || 20, 100)
  const result = await repo.findAll({ page, limit })
  respond(res, result)
}))

app.post('/api/users', asyncHandler(async (req, res) => {
  const user = await repo.create(req.body)
  respond(res, user, 201)
}))

app.get('/api/users/:id', asyncHandler(async (req, res) => {
  const user = await repo.findById(req.params.id)
  if (!user) { res.status(404).json({ success: false, error: 'Not found' }); return }
  respond(res, user)
}))

app.listen(3000, () => console.log('Server running on :3000'))
