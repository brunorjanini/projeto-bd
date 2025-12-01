import React from "react";

type Cell = React.ReactNode;

type TableProps = {
    headers: Cell[];
    rows: Cell[][];
    loading?: boolean;
    emptyMessage?: string;
    className?: string;
};

export const Table: React.FC<TableProps> = ({
    headers,
    rows,
    loading = false,
    emptyMessage = "Nenhum registro encontrado.",
    className = "",
}) => {
    const showEmpty = !loading && rows.length === 0;

    return (
        <div
            className={`
        w-full overflow-hidden rounded-xl border border-gray-200
        bg-white shadow-sm ${className}
      `}
        >
            <div className="max-h-[480px] overflow-auto">
                <table className="min-w-full border-collapse">
                    <thead className="bg-gray-50 sticky top-0 z-10">
                        <tr>
                            {headers.map((header, idx) => (
                                <th
                                    key={idx}
                                    className="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-gray-500"
                                >
                                    {header}
                                </th>
                            ))}
                        </tr>
                    </thead>

                    <tbody>
                        {loading && (
                            <tr>
                                <td
                                    colSpan={headers.length}
                                    className="px-4 py-6 text-sm text-gray-500 text-center"
                                >
                                    <div className="flex items-center justify-center gap-2">
                                        <span className="inline-block h-2 w-2 animate-ping rounded-full bg-blue-500" />
                                        Carregando...
                                    </div>
                                </td>
                            </tr>
                        )}

                        {showEmpty && (
                            <tr>
                                <td
                                    colSpan={headers.length}
                                    className="px-4 py-6 text-sm text-gray-400 text-center"
                                >
                                    {emptyMessage}
                                </td>
                            </tr>
                        )}

                        {!loading &&
                            rows.map((row, rowIndex) => (
                                <tr
                                    key={rowIndex}
                                    className="border-t border-gray-100 odd:bg-white even:bg-gray-50/70 hover:bg-blue-50/70 transition-colors"
                                >
                                    {row.map((cell, cellIndex) => (
                                        <td
                                            key={cellIndex}
                                            className="px-4 py-3 text-sm text-gray-700 align-middle"
                                        >
                                            {cell}
                                        </td>
                                    ))}
                                </tr>
                            ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
};
