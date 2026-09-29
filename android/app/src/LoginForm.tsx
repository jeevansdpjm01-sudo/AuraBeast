// @ts-nocheck
import React, { useState } from 'react';

export const LoginForm = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  // ⚡ Mock verification – replace with real API call
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    // Simulate network
    await new Promise((r) => setTimeout(r, 800));

    if (email !== 'user@example.com' || password !== 'password123') {
      setError('Invalid email or password');
      setLoading(false);
      return;
    }

    // ✅ Success
    setLoading(false);
    window.location.assign('/home'); // or your dashboard route
  };

  return (
    <form onSubmit={handleSubmit} style={{ maxWidth: 360, margin: 'auto' }}>
      <h2 style={{ textAlign: 'center' }}>Log in</h2>
      <div style={{ marginBottom: 12 }}>
        <label>Email</label>
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
          style={{ width: '100%', padding: 8, marginTop: 4 }}
        />
      </div>
      <div style={{ marginBottom: 12 }}>
        <label>Password</label>
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
          style={{ width: '100%', padding: 8, marginTop: 4 }}
        />
      </div>
      <button type="submit" disabled={loading} style={{ width: '100%', padding: 12 }}>
        {loading ? 'Logging in...' : 'Sign In'}
      </button>
      {error && <p style={{ color: 'red', textAlign: 'center', marginTop: 8 }}>{error}</p>}
    </form>
  );
};