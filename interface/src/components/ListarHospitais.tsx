import { Dropdown } from "./Dropdown";
import { useState } from "react";
import { Button } from "./Button";
import { Table } from "./Table";
import type { HospitalResumo } from "../schemas/transplantApi.schema";
import { transplantReadService } from "../services/transplantReadService";

function ListarHospitais() {
    const [tipoOrgao, setTipoOrgao] = useState<string>("");
    const [estado, setEstado] = useState<string>("");
    const [hospitais, setHospitais] = useState<HospitalResumo[]>([]);

    const filtrarHospitais = async () => {
        const hospitais = await transplantReadService.listarHospitais({
            central: estado ?? undefined,
            status: tipoOrgao ?? undefined,
        });
        if (hospitais) {
            setHospitais(hospitais);
        } else {
            setHospitais([]);
        }
        console.log(hospitais);
    }

    return (
        <div className="flex flex-col border-2 border-slate-300 rounded-3xl bg-white p-4 w-[90%] gap-3">
            <div className="flex gap-3">
                <div className="material-symbols-outlined text-gray-400 dark:text-gray-500">apartment</div>
                <div className="font-bold text-md">
                    Hopitais
                </div>
            </div>
            <div className="flex gap-5 w-full">
                <Dropdown
                    label="Tipo de orgão"
                    name="central"
                    value={tipoOrgao}
                    onChange={(value) => setTipoOrgao(value)}
                    options={[
                        { value: "", label: "Todos" },
                        { value: "Disponível", label: "Disponível" },
                        { value: "Em Transporte", label: "Em Transporte" },
                        { value: "Transplantado", label: "Transplantado" },
                    ]}
                    placeholder="Selecione uma opção"
                />
                <Dropdown
                    label="Estado da central"
                    name="central"
                    value={estado}
                    onChange={(value) => setEstado(value)}
                    options={[
                        { value: "", label: "Todos" },
                        { value: "AC", label: "Acre" },
                        { value: "AL", label: "Alagoas" },
                        { value: "AP", label: "Amapá" },
                        { value: "AM", label: "Amazonas" },
                        { value: "BA", label: "Bahia" },
                        { value: "CE", label: "Ceará" },
                        { value: "DF", label: "Distrito Federal" },
                        { value: "ES", label: "Espírito Santo" },
                        { value: "GO", label: "Goiás" },
                        { value: "MA", label: "Maranhão" },
                        { value: "MT", label: "Mato Grosso" },
                        { value: "MS", label: "Mato Grosso do Sul" },
                        { value: "MG", label: "Minas Gerais" },
                        { value: "PA", label: "Pará" },
                        { value: "PB", label: "Paraíba" },
                        { value: "PR", label: "Paraná" },
                        { value: "PE", label: "Pernambuco" },
                        { value: "PI", label: "Piauí" },
                        { value: "RJ", label: "Rio de Janeiro" },
                        { value: "RN", label: "Rio Grande do Norte" },
                        { value: "RS", label: "Rio Grande do Sul" },
                        { value: "RO", label: "Rondônia" },
                        { value: "RR", label: "Roraima" },
                        { value: "SC", label: "Santa Catarina" },
                        { value: "SP", label: "São Paulo" },
                        { value: "SE", label: "Sergipe" },
                        { value: "TO", label: "Tocantins" },
                    ]}
                    placeholder="Selecione uma opção"
                />
                <Button label="Filtrar" 
                className="h-10 my-auto ml-auto"
                onClick={filtrarHospitais} />

            </div>
            <Table
                headers={["Nome do hospital", "Cidade", "Número de órgãos disponíveis"]}
                rows={hospitais.map((hospital) => [
                    hospital.nomeHospital,
                    hospital.cidade,
                    hospital.totalOrgaosDisponiveis.toString(),
                ])}
                emptyMessage="Nenhum hospital encontrado com os filtros selecionados."
            />
        </div>
    )
}

export default ListarHospitais;