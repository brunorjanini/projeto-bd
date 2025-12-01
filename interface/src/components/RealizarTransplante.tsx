import { useState } from "react";
import { Button } from "./Button";
import { Input } from "./Input";
import { Dropdown } from "./Dropdown";
import { transplantWriteService } from "../services/transplantWriteService";

function RealizarTransplante() {
    const [idOrgao, setIdOrgao] = useState<string>("");
    const [idReceptor, setIdReceptor] = useState<string>("");
    const [statusTransplante, setStatusTransplante] = useState<string>("");
    const [mensagem, setMensagem] = useState<{ tipo: "success" | "error"; texto: string } | null>(null);
    const [loading, setLoading] = useState<boolean>(false);

    const realizarTransplante = async () => {
        if (!idOrgao || !idReceptor || !statusTransplante) {
            setMensagem({
                tipo: "error",
                texto: "Por favor, preencha todos os campos obrigatórios.",
            });
            return;
        }

        setLoading(true);
        setMensagem(null);

        const sucesso = await transplantWriteService.realizarTransplante({
            idOrgao: parseInt(idOrgao),
            idReceptor: parseInt(idReceptor),
            statusTransplante,
        });

        setLoading(false);

        if (sucesso) {
            setMensagem({
                tipo: "success",
                texto: "Transplante realizado com sucesso! O órgão foi transplantado, o contador do receptor foi atualizado e ele foi removido da fila.",
            });
            setIdOrgao("");
            setIdReceptor("");
            setStatusTransplante("");
        } else {
            setMensagem({
                tipo: "error",
                texto: "Erro ao realizar transplante. Verifique se os IDs são válidos e se o órgão está disponível.",
            });
        }
    };

    return (
        <div className="flex flex-col border-2 border-slate-300 rounded-3xl bg-white p-4 w-[90%] gap-3">
            <div className="flex gap-3">
                <div className="material-symbols-outlined text-gray-400 dark:text-gray-500">
                    volunteer_activism
                </div>
                <div className="font-bold text-md">Realizar Transplante</div>
            </div>

            <div className="text-sm text-gray-600 mb-2">
                Esta operação irá:
                <ul className="list-disc list-inside ml-2 mt-1">
                    <li>Inserir o registro de transplante</li>
                    <li>Atualizar o órgão para "Transplantado" e "Aprovado"</li>
                    <li>Incrementar o contador de transplantes do receptor</li>
                    <li>Remover o receptor da fila do órgão</li>
                </ul>
            </div>

            <div className="grid grid-cols-2 gap-4 w-full">
                <Input
                    label="ID do Órgão"
                    name="idOrgao"
                    type="number"
                    value={idOrgao}
                    onChange={(value) => setIdOrgao(value)}
                    placeholder="Ex: 10"
                    required
                />

                <Input
                    label="ID do Receptor"
                    name="idReceptor"
                    type="number"
                    value={idReceptor}
                    onChange={(value) => setIdReceptor(value)}
                    placeholder="Ex: 42"
                    required
                />

                <Dropdown
                    label="Status do Transplante"
                    name="statusTransplante"
                    value={statusTransplante}
                    onChange={(value) => setStatusTransplante(value)}
                    options={[
                        { value: "Agendado", label: "Agendado" },
                        { value: "Em andamento", label: "Em andamento" },
                        { value: "Concluído", label: "Concluído" },
                        { value: "Falhou", label: "Falhou" },
                        { value: "Cancelado", label: "Cancelado" },
                    ]}
                    placeholder="Selecione o status"
                />

            </div>

            <div className="flex gap-3 items-center mt-2">
                <Button
                    label={loading ? "Processando..." : "Realizar Transplante"}
                    className="h-10"
                    onClick={realizarTransplante}
                    disabled={loading}
                />
            </div>

            {mensagem && (
                <div
                    className={`p-4 rounded-lg mt-2 ${mensagem.tipo === "success"
                            ? "bg-green-50 border border-green-200 text-green-800"
                            : "bg-red-50 border border-red-200 text-red-800"
                        }`}
                >
                    <div className="flex items-start gap-2">
                        <span className="material-symbols-outlined text-sm">
                            {mensagem.tipo === "success" ? "check_circle" : "error"}
                        </span>
                        <p className="text-sm">{mensagem.texto}</p>
                    </div>
                </div>
            )}
        </div>
    );
}

export default RealizarTransplante;
