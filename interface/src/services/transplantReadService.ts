import { transplantApiProvider } from "../providers/transplantApiProvider";
import type {
  HospitalResumo,
  TransporteOrgao,
} from "../schemas/transplantApi.schema";

type AnyParams = Record<string, unknown>;

// helper: remove campos falsy ("" / null / undefined / false) do objeto
function cleanParams(params: AnyParams): AnyParams {
  const cleaned: AnyParams = {};
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined && value !== null && value !== "") {
      cleaned[key] = value;
    }
  }
  return cleaned;
}

class TransplantReadService {
  /**
   * Listar hospitais e quantidade de órgãos disponíveis
   * GET /relatorios/hospitais?central=XX&status=YYY
   */
  async listarHospitais(
    params: { central?: string; status?: string }
  ): Promise<HospitalResumo[] | null> {
    try {
      const query = cleanParams({
        central: params.central,
        status: params.status,
      });

      const response = await transplantApiProvider.get<HospitalResumo[]>(
        "/relatorios/hospitais",
        { params: query }
      );
      return response.data;
    } catch (error) {
      console.error("Erro ao listar hospitais", error);
      return null;
    }
  }

  /**
   * Transportes entre hospitais
   * GET /relatorios/transportes
   */
  async listarTransportes(params?: {
    origemLike?: string | null;
    destinoLike?: string | null;
    apenasConcluidos?: boolean | null;
  }): Promise<TransporteOrgao[] | null> {
    try {
      const query = cleanParams({
        origemLike: params?.origemLike,
        destinoLike: params?.destinoLike,
        apenasConcluidos: params?.apenasConcluidos,
      });

      const response = await transplantApiProvider.get<TransporteOrgao[]>(
        "/relatorios/transportes",
        { params: query }
      );
      return response.data;
    } catch (error) {
      console.error("Erro ao listar transportes", error);
      return null;
    }
  }
}

export const transplantReadService = new TransplantReadService();
