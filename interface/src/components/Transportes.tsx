import { Dropdown } from "./Dropdown";
import { useState } from "react";
import { Button } from "./Button";
import { Table } from "./Table";
import type { TransporteOrgao } from "../schemas/transplantApi.schema";
import { transplantReadService } from "../services/transplantReadService";

function Transportes() {
    const [origemLike, setOrigemLike] = useState<string>("");
    const [destinoLike, setDestinoLike] = useState<string>("");
    const [apenasConcluidos, setApenasConcluidos] = useState<string>("false");
    const [transportes, setTransportes] = useState<TransporteOrgao[]>([]);
    const [loading, setLoading] = useState<boolean>(false);

    const filtrarTransportes = async () => {
        setLoading(true);
        const resultado = await transplantReadService.listarTransportes({
            origemLike: origemLike || null,
            destinoLike: destinoLike || null,
            apenasConcluidos: apenasConcluidos === "true" ? true : apenasConcluidos === "false" ? false : null,
        });
        setTransportes(resultado || []);
        setLoading(false);
    };

    return (
        <div className="flex flex-col border-2 border-slate-300 rounded-3xl bg-white p-4 w-[90%] gap-3">
            <div className="flex gap-3">
                <div className="material-symbols-outlined text-gray-400 dark:text-gray-500 text-3xl">local_shipping</div>
                <div className="font-bold text-md">
                    Transportes de Órgãos
                </div>
            </div>
            <div className="flex gap-5 w-full">
                <div className="flex-1">
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                        Hospital de Origem
                    </label>
                    <input
                        type="text"
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="Ex: Hospital Vital SP"
                        value={origemLike}
                        onChange={(e) => setOrigemLike(e.target.value)}
                    />
                </div>
                <div className="flex-1">
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                        Hospital de Destino
                    </label>
                    <input
                        type="text"
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="Ex: Hospital Carioca"
                        value={destinoLike}
                        onChange={(e) => setDestinoLike(e.target.value)}
                    />
                </div>
                <Dropdown
                    label="Status"
                    name="status"
                    value={apenasConcluidos}
                    onChange={(value) => setApenasConcluidos(value)}
                    options={[
                        { value: "false", label: "Todos" },
                        { value: "true", label: "Apenas Concluídos" },
                    ]}
                    placeholder="Selecione uma opção"
                />
                <Button 
                    label="Filtrar" 
                    className="h-10 my-auto ml-auto"
                    onClick={filtrarTransportes} 
                />
            </div>
            <Table
                headers={[
                    "ID Órgão", 
                    "Tipo Órgão",
                    "Hospital Origem", 
                    "Hospital Destino", 
                    "Centro Transporte",
                    "Serial GPS",
                    "Tempo de Trânsito (h)"
                ]}
                rows={transportes.map((transporte) => [
                    transporte.idOrgao,
                    transporte.tipoOrgao,
                    transporte.hospitalOrigem,
                    transporte.hospitalDestino,
                    transporte.centroTransporte,
                    transporte.serialGps || "N/A",
                    transporte.tempoTransitoHoras !== null 
                        ? transporte.tempoTransitoHoras.toFixed(2) 
                        : "Em andamento",
                ])}
                loading={loading}
                emptyMessage="Nenhum transporte encontrado com os filtros selecionados."
            />
        </div>
    )
}

export default Transportes;