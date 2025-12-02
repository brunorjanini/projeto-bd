import axios from "axios";
import { transplantApiProvider } from "../providers/transplantApiProvider";
import type {
    CriarHospitalPayload,
    RealizarTransplantePayload,
    HospitalResumo,
} from "../schemas/transplantApi.schema";

class TransplantWriteService {
    /**
     * Criar hospital
     * POST /relatorios/hospitais?central=XX&status=YYY
     * Retorna a lista de hospitais atualizada.
     */
    async criarHospital(
        body: CriarHospitalPayload,
        params: { central: string; status: string }
    ): Promise<HospitalResumo[] | null> {
        try {
            const response = await transplantApiProvider.post<HospitalResumo[]>(
                "/relatorios/hospitais",
                body,
                {
                    params: {
                        central: params.central,
                        status: params.status,
                    },
                }
            );
            return response.data;
        } catch (error) {
            console.error("Erro ao criar hospital", error);
            throw error;
        }
    }

    /**
     * Realizar transplante completo
     * POST /transplantes
     * Insere transplante, atualiza órgão, incrementa contador e remove da fila.
     */
    async realizarTransplante(
        body: RealizarTransplantePayload
    ): Promise<boolean> {
        try {
            await transplantApiProvider.post("/transplantes", body);
            return true;
        } catch (error) {
            if (axios.isAxiosError(error)) {
                console.error("Erro Axios:", error.response?.data);

                throw new Error(
                    error.response?.data?.message ||
                    error.response?.data ||
                    error.message ||
                    "Erro desconhecido"
                );
            }

            throw new Error("Falha inesperada");
        }
    }
}

export const transplantWriteService = new TransplantWriteService();
