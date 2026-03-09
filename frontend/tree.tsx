import { useState, useMemo, type FC, type ReactNode } from 'react';

// ---- Types ----

interface Column<T> {
  key: keyof T & string;
  label: string;
  sortable?: boolean;
  render?: (value: T[keyof T], row: T) => ReactNode;
}

interface DataTableProps<T extends { id: string | number }> {
  columns: Column<T>[];
  data: T[];
  pageSize?: number;
  onRowClick?: (row: T) => void;
}

type SortDir = 'asc' | 'desc';

// ---- Helpers ----

function paginate<T>(items: T[], page: number, size: number): T[] {
  const start = (page - 1) * size;
  return items.slice(start, start + size);
}

function compare<T>(a: T, b: T, key: keyof T, dir: SortDir): number {
  const va = a[key], vb = b[key];
  const cmp = va < vb ? -1 : va > vb ? 1 : 0;
  return dir === 'asc' ? cmp : -cmp;
}

// ---- Components ----

function Pagination({ page, total, onChange }: {
  page: number;
  total: number;
  onChange: (p: number) => void;
}) {
  return (
    <nav className="pagination" aria-label="Table pagination">
      <button disabled={page <= 1} onClick={() => onChange(page - 1)}>
        Prev
      </button>
      <span>{page} / {total}</span>
      <button disabled={page >= total} onClick={() => onChange(page + 1)}>
        Next
      </button>
    </nav>
  );
}

function DataTable<T extends { id: string | number }>({
  columns, data, pageSize = 10, onRowClick,
}: DataTableProps<T>) {
  const [sortKey, setSortKey] = useState<keyof T | null>(null);
  const [sortDir, setSortDir] = useState<SortDir>('asc');
  const [page, setPage] = useState(1);

  const sorted = useMemo(() => {
    if (!sortKey) return data;
    return [...data].sort((a, b) => compare(a, b, sortKey, sortDir));
  }, [data, sortKey, sortDir]);

  const rows = useMemo(() => paginate(sorted, page, pageSize), [sorted, page, pageSize]);
  const totalPages = Math.max(1, Math.ceil(data.length / pageSize));

  const handleSort = (key: keyof T) => {
    if (sortKey === key) {
      setSortDir((d) => (d === 'asc' ? 'desc' : 'asc'));
    } else {
      setSortKey(key);
      setSortDir('asc');
    }
    setPage(1);
  };

  return (
    <div className="data-table-wrapper">
      <table className="data-table">
        <thead>
          <tr>
            {columns.map((col) => (
              <th
                key={col.key}
                onClick={col.sortable ? () => handleSort(col.key) : undefined}
                className={col.sortable ? 'sortable' : ''}
                aria-sort={sortKey === col.key ? sortDir + 'ending' : undefined}
              >
                {col.label}
                {sortKey === col.key && (sortDir === 'asc' ? ' ↑' : ' ↓')}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => (
            <tr key={row.id} onClick={() => onRowClick?.(row)} tabIndex={0}>
              {columns.map((col) => (
                <td key={col.key}>
                  {col.render ? col.render(row[col.key], row) : String(row[col.key])}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
      <Pagination page={page} total={totalPages} onChange={setPage} />
    </div>
  );
}

// ---- Demo Usage ----

interface Product {
  id: number;
  name: string;
  price: number;
  stock: number;
  category: string;
}

const columns: Column<Product>[] = [
  { key: 'name', label: 'Product', sortable: true },
  { key: 'category', label: 'Category', sortable: true },
  {
    key: 'price', label: 'Price', sortable: true,
    render: (v) => <span className="price">${(v as number).toFixed(2)}</span>,
  },
  {
    key: 'stock', label: 'Stock', sortable: true,
    render: (v) => (
      <span className={(v as number) < 10 ? 'low-stock' : ''}>
        {v as number}
      </span>
    ),
  },
];

const App: FC = () => {
  const [products] = useState<Product[]>([
    { id: 1, name: 'Mechanical Keyboard', price: 129.99, stock: 45, category: 'Peripherals' },
    { id: 2, name: 'USB-C Hub', price: 49.99, stock: 8, category: 'Accessories' },
    { id: 3, name: '4K Monitor', price: 599.00, stock: 12, category: 'Displays' },
    { id: 4, name: 'Wireless Mouse', price: 79.99, stock: 3, category: 'Peripherals' },
  ]);

  return (
    <main>
      <h1>Inventory</h1>
      <DataTable columns={columns} data={products} pageSize={10} />
    </main>
  );
};

export default App;
