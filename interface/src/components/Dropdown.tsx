import React from "react";

type Option = {
    value: string;
    label: string;
};

type DropdownProps = {
    label?: string;
    name?: string;
    value: string;
    onChange: (value: string) => void;
    options: Option[];
    placeholder?: string;
    disabled?: boolean;
};

export const Dropdown: React.FC<DropdownProps> = ({
    label,
    name,
    value,
    onChange,
    options,
    placeholder,
    disabled = false,
}) => {
    const id = name || label || "dropdown";

    return (
        <div className="flex flex-col gap-1">
            {label && (
                <label htmlFor={id} className="text-sm font-medium text-gray-700">
                    {label}
                </label>
            )}

            <select
                id={id}
                name={name}
                value={value}
                disabled={disabled}
                onChange={(e) => onChange(e.target.value)}
                className="border border-gray-300 rounded-md px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
                {placeholder && (
                    <option value="" disabled>
                        {placeholder}
                    </option>
                )}

                {options.map((opt) => (
                    <option key={opt.value} value={opt.value}>
                        {opt.label}
                    </option>
                ))}
            </select>
        </div>
    );
};
