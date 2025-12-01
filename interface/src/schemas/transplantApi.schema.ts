
// --- READ ---

export interface HospitalResumo {
  nomeHospital: string;
  cidade: string;
  totalOrgaosDisponiveis: number;
}

export interface TransporteOrgao {
  idOrgao: number;
  tipoOrgao: string;
  hospitalOrigem: string;
  hospitalDestino: string;
  centroTransporte: string;
  serialGps: string | null;
  tempoTransitoHoras: number | null;
}

// --- WRITE (payloads de entrada) ---

export interface CriarHospitalPayload {
  nome: string;
  cnpj: string;
  telefone: string;
  email: string;
  rua: string;
  numero: string;
  bairro: string;
  cidade: string;
  centralEstadual: string;
}

export interface RealizarTransplantePayload {
  idOrgao: number;
  idReceptor: number;
  statusTransplante: string;
}
