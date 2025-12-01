import axios from "axios";

export const transplantApiProvider = axios.create({
    baseURL: import.meta.env.VITE_TRANSPLANT_API_URL,
    headers: {
        "Content-Type": "application/json",
    },
    timeout: 10000,
});
