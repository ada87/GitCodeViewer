import { useState, useEffect, useCallback } from 'react';

const API_BASE = '/api/v1';

function useDebounce(value, delay = 300) {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);
  return debounced;
}

function Badge({ count, color = 'blue' }) {
  if (count === 0) return null;
  return (
    <span className={`badge badge-${color}`}>
      {count > 99 ? '99+' : count}
    </span>
  );
}

function SearchBar({ onSearch, placeholder = 'Search...' }) {
  const [query, setQuery] = useState('');
  const debounced = useDebounce(query);

  useEffect(() => {
    onSearch(debounced);
  }, [debounced, onSearch]);

  return (
    <div className="search-bar">
      <input
        type="text"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder={placeholder}
        aria-label="Search"
      />
      {query && (
        <button onClick={() => setQuery('')} aria-label="Clear">
          ×
        </button>
      )}
    </div>
  );
}

export default function UserList() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchUsers = useCallback(async (search = '') => {
    setLoading(true);
    try {
      const url = search
        ? `${API_BASE}/users?q=${encodeURIComponent(search)}`
        : `${API_BASE}/users`;
      const res = await fetch(url);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      setUsers(await res.json());
      setError(null);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { fetchUsers(); }, [fetchUsers]);

  if (error) {
    return (
      <div className="error-panel" role="alert">
        <p>Failed to load: {error}</p>
        <button onClick={() => fetchUsers()}>Retry</button>
      </div>
    );
  }

  return (
    <section className="user-list">
      <SearchBar onSearch={fetchUsers} placeholder="Search users..." />
      {loading ? (
        <div className="skeleton-grid">
          {Array.from({ length: 6 }, (_, i) => (
            <div key={i} className="skeleton-card" />
          ))}
        </div>
      ) : (
        <ul>
          {users.map((user) => (
            <li key={user.id} className="user-card">
              <img src={user.avatar} alt={user.name} loading="lazy" />
              <div>
                <h3>{user.name}</h3>
                <p>{user.email}</p>
              </div>
              <Badge count={user.notifications} />
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}
