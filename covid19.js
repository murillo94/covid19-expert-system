const MENSAGEM_GRAVIDADE_LEVE = 'deve ficar em casa, em observação por 14 dias';
const MENSAGEM_GRAVIDADE_GRAVE = 'deve ser encaminhado para o hospital';
const QUANTIDADE_DE_PACIENTES = 5;

const GRAVIDADES = {
  gravissimo: {
    criterios: {
      frequencia_respiratoria: (x) => x > 30,
      pa_sistolica: (x) => x < 90,
      saO2: (x) => x < 95,
      dispneia: (x) => !!x,
    },
    mensagem: MENSAGEM_GRAVIDADE_GRAVE,
  },
  grave: {
    criterios: {
      temperatura: (x) => x > 39,
      pa_sistolica: (x) => x >= 90 && x <= 100,
      idade: (x) => x > 80,
      comorbidade: (x) => x > 2,
    },
    mensagem: MENSAGEM_GRAVIDADE_GRAVE,
  },
  medio: {
    criterios: {
      temperatura: (x) => x < 35 || (x >= 37 && x <= 39),
      frequencia_cardiaca: (x) => x > 100,
      frequencia_respiratoria: (x) => x >= 19 && x <= 30,
      idade: (x) => x >= 60 && x <= 79,
      comorbidade: (x) => x === 1,
    },
    mensagem: MENSAGEM_GRAVIDADE_LEVE,
  },
  leve: {
    criterios: {
      temperatura: (x) => x >= 35 && x <= 37,
      frequencia_cardiaca: (x) => x < 100,
      frequencia_respiratoria: (x) => x < 18,
      pa_sistolica: (x) => x > 100,
      saO2: (x) => x >= 95,
      dispneia: (x) => !x,
      idade: (x) => x < 60,
      comorbidade: (x) => x === 0,
    },
    mensagem: MENSAGEM_GRAVIDADE_LEVE,
  },
};

function obterDados(quantidade_de_pacientes) {
  const dadosRandomicos = [];

  const obterValorRandomico = (min, max) =>
    Math.floor(Math.random() * (max - min + 1)) + min;

  for (let x = 0; x < quantidade_de_pacientes; x++) {
    dadosRandomicos[x] = {
      temperatura: obterValorRandomico(25, 49),
      frequencia_cardiaca: obterValorRandomico(90, 110),
      frequencia_respiratoria: obterValorRandomico(8, 40),
      pa_sistolica: obterValorRandomico(90, 110),
      saO2: obterValorRandomico(85, 105),
      dispneia: !!obterValorRandomico(0, 1),
      idade: obterValorRandomico(0, 100),
      comorbidade: obterValorRandomico(0, 5),
    };
  }

  return dadosRandomicos;
}

let resultado = [];
const dados = obterDados(QUANTIDADE_DE_PACIENTES);

for (let [posicao, dado] of dados.entries()) {
  for (gravidade in GRAVIDADES) {
    let regrasValidas = 0;
    const regras = GRAVIDADES[gravidade].criterios;
    const mensagem = GRAVIDADES[gravidade].mensagem;

    for (regra in regras) {
      const fn_regra = regras[regra];

      if (regrasValidas >= 2) break;
      if (regra in dado && fn_regra(dado[regra])) regrasValidas++;
    }

    if (regrasValidas >= 2) {
      resultado = [
        ...resultado,
        {
          paciente_id: posicao,
          estado: gravidade,
          mensagem,
        },
      ];

      break;
    }
  }
}

console.log(resultado);
