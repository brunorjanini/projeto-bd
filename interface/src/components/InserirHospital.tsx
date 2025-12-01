import { useState } from "react";
import { Input } from "./Input";
import { Dropdown } from "./Dropdown";
import { Button } from "./Button";
import { Table } from "./Table";
import type { CriarHospitalPayload, HospitalResumo } from "../schemas/transplantApi.schema";
import { transplantWriteService } from "../services/transplantWriteService";

function InserirHospital() {
    // Estados do formulário
    const [nome, setNome] = useState<string>("");
    const [cnpj, setCnpj] = useState<string>("");
    const [telefone, setTelefone] = useState<string>("");
    const [email, setEmail] = useState<string>("");
    const [rua, setRua] = useState<string>("");
    const [numero, setNumero] = useState<string>("");
    const [bairro, setBairro] = useState<string>("");
    const [cidade, setCidade] = useState<string>("");
    const [centralEstadual, setCentralEstadual] = useState<string>("");

    // Estados de consulta
    const [statusFiltro, setStatusFiltro] = useState<string>("Disponível");
    const [hospitalCriado, setHospitalCriado] = useState<boolean>(false);
    const [hospitais, setHospitais] = useState<HospitalResumo[]>([]);
    const [loading, setLoading] = useState<boolean>(false);
    const [error, setError] = useState<string>("");

    const limparFormulario = () => {
        setNome("");
        setCnpj("");
        setTelefone("");
        setEmail("");
        setRua("");
        setNumero("");
        setBairro("");
        setCidade("");
        setCentralEstadual("");
        setError("");
    };

    const validarFormulario = (): boolean => {
        if (!nome.trim()) {
            setError("Nome do hospital é obrigatório");
            return false;
        }
        if (!cnpj.trim()) {
            setError("CNPJ é obrigatório");
            return false;
        }
        if (!telefone.trim()) {
            setError("Telefone é obrigatório");
            return false;
        }
        if (!email.trim()) {
            setError("Email é obrigatório");
            return false;
        }
        if (!rua.trim()) {
            setError("Rua é obrigatória");
            return false;
        }
        if (!numero.trim()) {
            setError("Número é obrigatório");
            return false;
        }
        if (!bairro.trim()) {
            setError("Bairro é obrigatório");
            return false;
        }
        if (!cidade.trim()) {
            setError("Cidade é obrigatória");
            return false;
        }
        if (!centralEstadual.trim()) {
            setError("Central Estadual é obrigatória");
            return false;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            setError("Email inválido");
            return false;
        }

        const cnpjRegex = /^\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$/;
        if (!cnpjRegex.test(cnpj)) {
            setError("CNPJ deve estar no formato: XX.XXX.XXX/XXXX-XX");
            return false;
        }

        return true;
    };

    const handleCriarHospital = async () => {
        setError("");
        
        if (!validarFormulario()) {
            return;
        }

        setLoading(true);

        const payload: CriarHospitalPayload = {
            nome: nome.trim(),
            cnpj: cnpj.trim(),
            telefone: telefone.trim(),
            email: email.trim(),
            rua: rua.trim(),
            numero: numero.trim(),
            bairro: bairro.trim(),
            cidade: cidade.trim(),
            centralEstadual: centralEstadual.trim(),
        };

        try {
            const resultado = await transplantWriteService.criarHospital(
                payload,
                {
                    central: centralEstadual.trim(),
                    status: statusFiltro,
                }
            );

            if (resultado) {
                setHospitais(resultado);
                setHospitalCriado(true);
                limparFormulario();
                setError("");
            } else {
                setError("Erro ao criar hospital. Verifique os dados e tente novamente.");
            }
        } catch (err) {
            setError("Erro ao criar hospital. Verifique os dados e tente novamente.");
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="flex flex-col border-2 border-slate-300 rounded-3xl bg-white p-6 w-[90%] gap-4">
            <div className="flex gap-3 items-center border-b pb-3">
                <div className="material-symbols-outlined text-blue-500 text-4xl">
                    local_hospital
                </div>
                <div>
                    <h2 className="font-bold text-xl text-gray-800">
                        Cadastrar Novo Hospital
                    </h2>
                    <p className="text-sm text-gray-500">
                        Preencha os dados abaixo para cadastrar um hospital no sistema
                    </p>
                </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <Input
                    label="Nome do Hospital"
                    name="nome"
                    value={nome}
                    onChange={setNome}
                    placeholder="Ex: Hospital das Clínicas"
                    required
                />

                <Input
                    label="CNPJ"
                    name="cnpj"
                    value={cnpj}
                    onChange={setCnpj}
                    placeholder="XX.XXX.XXX/XXXX-XX"
                    required
                />

                <Input
                    label="Telefone"
                    name="telefone"
                    value={telefone}
                    onChange={setTelefone}
                    placeholder="(XX) XXXXX-XXXX"
                    required
                />

                <Input
                    label="Email"
                    name="email"
                    type="email"
                    value={email}
                    onChange={setEmail}
                    placeholder="contato@hospital.com.br"
                    required
                />

                <Input
                    label="Rua"
                    name="rua"
                    value={rua}
                    onChange={setRua}
                    placeholder="Ex: Av. Dr. Enéas Carvalho de Aguiar"
                    required
                />

                <Input
                    label="Número"
                    name="numero"
                    value={numero}
                    onChange={setNumero}
                    placeholder="Ex: 255"
                    required
                />

                <Input
                    label="Bairro"
                    name="bairro"
                    value={bairro}
                    onChange={setBairro}
                    placeholder="Ex: Cerqueira César"
                    required
                />

                <Input
                    label="Cidade"
                    name="cidade"
                    value={cidade}
                    onChange={setCidade}
                    placeholder="Ex: São Paulo"
                    required
                />

                <Dropdown
                    label="Central Estadual (UF)"
                    name="centralEstadual"
                    value={centralEstadual}
                    onChange={setCentralEstadual}
                    options={[
                        { value: "", label: "Selecione um estado" },
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
                    placeholder="Selecione o estado"
                />

                <Dropdown
                    label="Status de Órgãos para Consulta"
                    name="statusFiltro"
                    value={statusFiltro}
                    onChange={setStatusFiltro}
                    options={[
                        { value: "Disponível", label: "Disponível" },
                        { value: "Em Transporte", label: "Em Transporte" },
                        { value: "Transplantado", label: "Transplantado" },
                    ]}
                    placeholder="Selecione o status"
                />
            </div>

            {error && (
                <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
                    <div className="flex items-center gap-2">
                        <span className="material-symbols-outlined text-red-500">error</span>
                        <span>{error}</span>
                    </div>
                </div>
            )}

            {hospitalCriado && !error && (
                <div className="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg">
                    <div className="flex items-center gap-2">
                        <span className="material-symbols-outlined text-green-500">check_circle</span>
                        <span>Hospital cadastrado com sucesso!</span>
                    </div>
                </div>
            )}

            <div className="flex gap-3 justify-end">
                <Button
                    label="Limpar Formulário"
                    onClick={limparFormulario}
                    className="bg-gray-500 hover:bg-gray-600"
                />
                <Button
                    label={loading ? "Cadastrando..." : "Cadastrar Hospital"}
                    onClick={handleCriarHospital}
                    disabled={loading}
                />
            </div>

            {hospitalCriado && hospitais.length > 0 && (
                <div className="mt-4">
                    <h3 className="font-semibold text-lg mb-3 text-gray-800">
                        Hospitais da Central {centralEstadual} com órgãos "{statusFiltro}"
                    </h3>
                    <Table
                        headers={["Nome do Hospital", "Cidade", "Total de Órgãos Disponíveis"]}
                        rows={hospitais.map((hospital) => [
                            hospital.nomeHospital,
                            hospital.cidade,
                            hospital.totalOrgaosDisponiveis,
                        ])}
                        loading={loading}
                        emptyMessage="Nenhum hospital encontrado."
                    />
                </div>
            )}
        </div>
    );
}

export default InserirHospital;
