import React from "react";

type ButtonProps = {
    label: string;
    onClick?: () => void;
    disabled?: boolean;
    type?: "button" | "submit" | "reset";
    className?: string;
};

export const Button: React.FC<ButtonProps> = ({
    label,
    onClick,
    disabled = false,
    type = "button",
    className = "",
}) => {
    return (
        <button
            type={type}
            onClick={onClick}
            disabled={disabled}
            className={`
        relative overflow-hidden select-none
        px-6 py-3 rounded-full
        bg-linear-to-r from-blue-500 via-blue-600 to-blue-700
        text-white font-semibold tracking-wide
        shadow-lg
        transition-all duration-200 ease-out
        hover:brightness-110 hover:scale-[1.03]
        active:scale-95
        cursor-pointer
        focus:outline-none
        ring-0 ring-offset-0
        disabled:opacity-50 disabled:cursor-not-allowed
        flex justify-center items-center
        ${className}
      `}
        >
            <span className="relative z-10">{label}</span>

            <span
                className="
          absolute inset-0
          bg-linear-to-r from-blue-300/30 to-blue-500/30
          opacity-0
          hover:opacity-100
          transition-opacity duration-300
          pointer-events-none
        "
            />
        </button>
    );
};
