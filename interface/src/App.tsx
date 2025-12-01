import ListarHospitais from "./components/ListarHospitais";
import Transportes from "./components/Transportes";
import RealizarTransplante from "./components/RealizarTransplante";
import InserirHospital from "./components/InserirHospital";

function App() {
    return (
        <div className="flex flex-col w-screen min-h-screen bg-[#f6f7f8]">
            <div className="h-32 bg-white flex items-center justify-start gap-3 border-b-2 border-slate-200">
                <div className="text-blue-400 w-16 h-16">
                    <svg
                        fill="none"
                        viewBox="0 0 48 48"
                        xmlns="http://www.w3.org/2000/svg"
                        className="w-full h-full"
                    >
                        <path
                            d="M24 4H6V17.3333V30.6667H24V44H42V30.6667V17.3333H24V4Z"
                            fill="currentColor"
                            fillRule="evenodd"
                            clipRule="evenodd"
                        />
                    </svg>
                </div>
                <p className="text-gray-900 text-2xl font-bold">
                    Sistema de Gestão de Transplantes
                </p>
            </div>
            <div className="flex flex-col justify-center items-center gap-8 w-full p-10">
                <ListarHospitais />
                <InserirHospital />
                <Transportes />
                <RealizarTransplante />

            </div>
        </div>
    );
}


export default App;
