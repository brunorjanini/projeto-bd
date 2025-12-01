import React from "react";

type InputProps = {
    label?: string;
    name?: string;
    value: string | number;
    onChange: (value: string) => void;
    type?: "text" | "number" | "email" | "password" | "date" | "datetime-local";
    placeholder?: string;
    disabled?: boolean;
    required?: boolean;
    className?: string;
};

export const Input: React.FC<InputProps> = ({
    label,
    name,
    value,
    onChange,
    type = "text",
    placeholder,
    disabled = false,
    required = false,
    className = "",
}) => {
    const id = name || label || "input";

    return (
        <div className={`flex flex-col gap-1 ${className}`}>
            {label && (
                <label htmlFor={id} className="text-sm font-medium text-gray-700">
                    {label}
                    {required && <span className="text-red-500 ml-1">*</span>}
                </label>
            )}

            <input
                id={id}
                name={name}
                type={type}
                value={value}
                disabled={disabled}
                required={required}
                placeholder={placeholder}
                onChange={(e) => onChange(e.target.value)}
                className="border border-gray-300 rounded-md px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 disabled:bg-gray-100 disabled:cursor-not-allowed"
            />
        </div>
    );
};
