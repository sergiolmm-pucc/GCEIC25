// Teste Unitário Grupo 09 - Cálculo de Aposentadoria

const {
  calcularAposentadoria,
  calcularRegra,
  calcularTempoAposentadoria,
  calcularPontuacao,
  obterHistorico,
  historicoOperacoes,
} = require("../controllers/aposController");

function mockResponse(req = {}) {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn(function (data) {
    if (req.originalUrl !== "/historico") {
      historicoOperacoes.push({
        tipo: req.originalUrl,
        dados: req.body,
        resultado: data,
        timestamp: new Date().toISOString(),
      });

      if (historicoOperacoes.length > 100) {
        historicoOperacoes.splice(0, historicoOperacoes.length - 100);
      }
    }
    return res;
  });
  return res;
}

// Isabella Tressino
describe("Função calcularAposentadoria", () => {
  test("Mulher que já pode se aposentar", () => {
    const req = { body: { idade: 62, contribuicao: 15, sexo: "F" } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith({
      podeAposentar: true,
      mensagem: "Você já pode se aposentar.",
    });
  });

  test("Homem que já pode se aposentar", () => {
    const req = { body: { idade: 65, contribuicao: 15, sexo: "M" } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith({
      podeAposentar: true,
      mensagem: "Você já pode se aposentar.",
    });
  });

  test("Mulher que não pode se aposentar por idade", () => {
    const req = { body: { idade: 60, contribuicao: 15, sexo: "F" } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        podeAposentar: false,
        mensagem: expect.stringContaining("2 ano(s) de idade"),
      })
    );
  });

  test("Homem que não pode se aposentar por contribuição", () => {
    const req = { body: { idade: 65, contribuicao: 10, sexo: "M" } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        podeAposentar: false,
        mensagem: expect.stringContaining("5 ano(s) de contribuição"),
      })
    );
  });

  test("Mulher que não pode se aposentar por idade e contribuição", () => {
    const req = { body: { idade: 60, contribuicao: 10, sexo: "F" } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        podeAposentar: false,
        mensagem: expect.stringContaining("2 ano(s) de idade"),
      })
    );
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        mensagem: expect.stringContaining("5 ano(s) de contribuição"),
      })
    );
  });

  test("Idade negativa", () => {
    const req = { body: { idade: -1, contribuicao: 15, sexo: "F" } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        podeAposentar: false,
        mensagem: expect.any(String),
      })
    );
  });

  test("Contribuição negativa", () => {
    const req = { body: { idade: 62, contribuicao: -5, sexo: "M" } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        podeAposentar: false,
        mensagem: expect.any(String),
      })
    );
  });
});

// Izabelle Oliveira

// Emilly Ferro
describe("Função calcularPontuacao", () => {
  // Teste 1: Já pode aposentar pela pontuação (mulher)
  test("Mulher que já pode se aposentar por pontuação", () => {
    const req = { body: { idade: 60, contribuicao: 40, sexo: "F" } }; // Pontuação: 100
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith({
      pontuacaoAtual: 100,
      anosRestantes: 0,
      mensagem: expect.stringContaining("já tem pontuação suficiente"),
    });
  });

  // Teste 2: Já pode aposentar pela pontuação (homem)
  test("Homem que já pode se aposentar por pontuação", () => {
    const req = { body: { idade: 65, contribuicao: 40, sexo: "M" } }; // Pontuação: 105
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith({
      pontuacaoAtual: 105,
      anosRestantes: 0,
      mensagem: expect.stringContaining("já tem pontuação suficiente"),
    });
  });

  // Teste 3: Faltam anos para mulher (ex: 50+25 = 75, precisa de 100 -> faltam 25 pontos / 2 pontos/ano = 12.5 anos ~ 13 anos)
  // Re-calculando: 75 -> 77 (1 ano), 79 (2 anos), ..., 99 (12 anos), 101 (13 anos)
  test("Mulher que faltam anos para atingir a pontuação", () => {
    const req = { body: { idade: 50, contribuicao: 25, sexo: "F" } }; // Pontuação: 75
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        pontuacaoAtual: 75,
        anosRestantes: 13, // 75 -> 77, 79, 81, 83, 85, 87, 89, 91, 93, 95, 97, 99, 101 (13 anos)
        mensagem: expect.stringContaining(
          "13 ano(s) de contribuição e idade para atingir a pontuação necessária (100)."
        ),
      })
    );
  });

  // Teste 4: Faltam anos para homem (ex: 55+30 = 85, precisa de 105 -> faltam 20 pontos / 2 pontos/ano = 10 anos)
  test("Homem que faltam anos para atingir a pontuação", () => {
    const req = { body: { idade: 55, contribuicao: 30, sexo: "M" } }; // Pontuação: 85
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        pontuacaoAtual: 85,
        anosRestantes: 10, // 85 -> 87, ..., 105 (10 anos)
        mensagem: expect.stringContaining(
          "10 ano(s) de contribuição e idade para atingir a pontuação necessária (105)."
        ),
      })
    );
  });

  // Teste 5: Idade zero ou baixa, mas contribuição alta
  test("Homem com idade baixa mas alta contribuição, faltando poucos anos", () => {
    const req = { body: { idade: 30, contribuicao: 70, sexo: "M" } }; // Pontuação: 100
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        pontuacaoAtual: 100,
        anosRestantes: 3, // 100 -> 102 (1 ano), 104 (2 anos), 106 (3 anos)
        mensagem: expect.stringContaining(
          "3 ano(s) de contribuição e idade para atingir a pontuação necessária (105)."
        ),
      })
    );
  });

  // Teste 6: Idade negativa deve retornar erro
  test("Idade negativa deve retornar erro", () => {
    const req = { body: { idade: -5, contribuicao: 20, sexo: "F" } };
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        erro: true,
        mensagem: expect.stringContaining("idade, contribuicao válidos e sexo"),
      })
    );
  });

  // Teste 7: Contribuição negativa deve retornar erro
  test("Contribuição negativa deve retornar erro", () => {
    const req = { body: { idade: 50, contribuicao: -10, sexo: "M" } };
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        erro: true,
        mensagem: expect.stringContaining("idade, contribuicao válidos e sexo"),
      })
    );
  });

  // Teste 8: Sexo inválido deve retornar erro
  test("Sexo inválido deve retornar erro", () => {
    const req = { body: { idade: 50, contribuicao: 20, sexo: "Z" } };
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        erro: true,
        mensagem: expect.stringContaining("idade, contribuicao válidos e sexo"),
      })
    );
  });

  // Teste 9: Dados incompletos (idade faltando) deve retornar erro
  test("Dados incompletos (idade faltando) deve retornar erro", () => {
    const req = { body: { contribuicao: 20, sexo: "F" } };
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        erro: true,
        mensagem:
          'Por favor, envie idade, contribuicao válidos e sexo ("M" ou "F").',
      })
    );
  });

  // Teste 10: Dados incompletos (contribuicao faltando) deve retornar erro
  test("Dados incompletos (contribuicao faltando) deve retornar erro", () => {
    const req = { body: { idade: 50, sexo: "M" } };
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        erro: true,
        mensagem:
          'Por favor, envie idade, contribuicao válidos e sexo ("M" ou "F").',
      })
    );
  });

  // Teste 11: Pontuação exata (mulher)
  test("Mulher com pontuação exata no limite (100)", () => {
    const req = { body: { idade: 50, contribuicao: 50, sexo: "F" } }; // Pontuação: 100
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith({
      pontuacaoAtual: 100,
      anosRestantes: 0,
      mensagem: expect.stringContaining("já tem pontuação suficiente"),
    });
  });

  // Teste 12: Pontuação exata (homem)
  test("Homem com pontuação exata no limite (105)", () => {
    const req = { body: { idade: 55, contribuicao: 50, sexo: "M" } }; // Pontuação: 105
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith({
      pontuacaoAtual: 105,
      anosRestantes: 0,
      mensagem: expect.stringContaining("já tem pontuação suficiente"),
    });
  });
});

// Gabriel Cardoso
describe("Rotas de Histórico", () => {
  beforeEach(() => {
    historicoOperacoes.length = 0;
  });

  test("Deve registrar uma operação no histórico", () => {
    const req = {
      body: { idade: 60, contribuicao: 30, sexo: "F" },
      originalUrl: "/calculoAposentadoria",
    };
    const res = mockResponse(req);
    calcularAposentadoria(req, res);

    const histReq = { query: {}, originalUrl: "/historico" };
    const histRes = mockResponse(histReq);
    obterHistorico(histReq, histRes);

    expect(histRes.status).toHaveBeenCalledWith(200);
    expect(histRes.json).toHaveBeenCalledWith(
      expect.objectContaining({
        historico: expect.any(Array),
      })
    );

    const historico = histRes.json.mock.calls[0][0].historico;
    expect(historico.length).toBeGreaterThan(0);
    expect(historico[0]).toEqual(
      expect.objectContaining({
        tipo: "/calculoAposentadoria",
        dados: expect.any(Object),
        resultado: expect.any(Object),
        timestamp: expect.any(String),
      })
    );
  });

  test("Deve filtrar histórico por tipo", () => {
    const req1 = {
      body: { idade: 60, contribuicao: 30, sexo: "F" },
      originalUrl: "/calculoAposentadoria",
    };
    const res1 = mockResponse(req1);
    calcularAposentadoria(req1, res1);

    const req2 = {
      query: { tipo: "/calculoAposentadoria" },
      originalUrl: "/historico",
    };
    const res2 = mockResponse(req2);
    obterHistorico(req2, res2);

    const historicoFiltrado = res2.json.mock.calls[0][0].historico;
    expect(res2.status).toHaveBeenCalledWith(200);
    expect(
      historicoFiltrado.every((op) => op.tipo === "/calculoAposentadoria")
    ).toBe(true);
  });

  test("Deve limitar o histórico a 100 operações", () => {
    for (let i = 0; i < 110; i++) {
      const req = {
        body: {
          idade: 60 + (i % 10),
          contribuicao: 30 + (i % 5),
          sexo: i % 2 === 0 ? "F" : "M",
        },
        originalUrl: "/calculoAposentadoria",
      };
      calcularAposentadoria(req, mockResponse(req));
    }

    const res = mockResponse({ originalUrl: "/historico", query: {} });
    obterHistorico({ query: {} }, res);

    const historico = res.json.mock.calls[0][0].historico;
    expect(historico.length).toBeLessThanOrEqual(100);
  });

  test("Deve ordenar histórico do mais recente para o mais antigo", async () => {
    const req1 = {
      body: { idade: 60, contribuicao: 30, sexo: "F" },
      originalUrl: "/calculoAposentadoria",
    };
    calcularAposentadoria(req1, mockResponse(req1));

    await new Promise((resolve) => setTimeout(resolve, 100));

    const req2 = {
      body: { idade: 65, contribuicao: 35, sexo: "M" },
      originalUrl: "/calculoAposentadoria",
    };
    calcularAposentadoria(req2, mockResponse(req2));

    const res = mockResponse({ originalUrl: "/historico" });
    obterHistorico({ query: {} }, res);

    const timestamps = res.json.mock.calls[0][0].historico.map((op) =>
      new Date(op.timestamp).getTime()
    );

    expect(timestamps[0]).toBeGreaterThan(timestamps[1]);
  });

  test("Deve registrar diferentes tipos de operações", () => {
    const mockCalls = [
      {
        func: calcularAposentadoria,
        url: "/calculoAposentadoria",
        body: { idade: 60, contribuicao: 30, sexo: "F" },
      },
      {
        func: calcularRegra,
        url: "/calculoRegra",
        body: {
          sexo: "masculino",
          idade: 65,
          tempoContribuicao: 35,
          categoria: "professor",
        },
      },
      {
        func: calcularPontuacao,
        url: "/calculoPontuacao",
        body: { idade: 60, contribuicao: 30, sexo: "F" },
      },
      {
        func: calcularTempoAposentadoria,
        url: "/calculoTempoAposentadoria",
        body: { idade: 60, contribuicao: 30, sexo: "F" },
      },
    ];

    for (const { func, url, body } of mockCalls) {
      const req = { body, originalUrl: url };
      func(req, mockResponse(req));
    }

    const res = mockResponse({ originalUrl: "/historico" });
    obterHistorico({ query: {} }, res);

    const tipos = new Set(
      res.json.mock.calls[0][0].historico.map((op) => op.tipo)
    );
    expect(tipos.has("/calculoAposentadoria")).toBe(true);
    expect(tipos.has("/calculoRegra")).toBe(true);
    expect(tipos.has("/calculoPontuacao")).toBe(true);
    expect(tipos.has("/calculoTempoAposentadoria")).toBe(true);
  });
});

// Guilherme Maia
describe("Função calcularTempoAposentadoria", () => {
  test("Pessoa que já pode se aposentar", () => {
    const req = { body: { idade: 65, contribuicao: 15, sexo: "M" } };
    const res = mockResponse();

    calcularTempoAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        anosPrevistosParaAposentar: 0,
        mensagem: "Você já pode se aposentar!",
      })
    );
  });

  test("Pessoa que falta tempo para idade mínima", () => {
    const req = { body: { idade: 60, contribuicao: 15, sexo: "M" } };
    const res = mockResponse();
    const anoAtual = new Date().getFullYear();

    calcularTempoAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        anosPrevistosParaAposentar: 5,
        anoPrevisoAposentadoria: anoAtual + 5,
        detalhes: {
          idadeAtual: 60,
          idadeNaAposentadoria: 65,
          contribuicaoAtual: 15,
          contribuicaoNaAposentadoria: 20,
        },
      })
    );
  });

  test("Pessoa que falta tempo de contribuição", () => {
    const req = { body: { idade: 65, contribuicao: 10, sexo: "M" } };
    const res = mockResponse();
    const anoAtual = new Date().getFullYear();

    calcularTempoAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        anosPrevistosParaAposentar: 5,
        anoPrevisoAposentadoria: anoAtual + 5,
        detalhes: {
          idadeAtual: 65,
          idadeNaAposentadoria: 70,
          contribuicaoAtual: 10,
          contribuicaoNaAposentadoria: 15,
        },
      })
    );
  });

  test("Dados incompletos", () => {
    const req = { body: { idade: 60 } }; // Faltando contribuicao e sexo
    const res = mockResponse();

    calcularTempoAposentadoria(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      erro: "Dados incompletos",
    });
  });
});
