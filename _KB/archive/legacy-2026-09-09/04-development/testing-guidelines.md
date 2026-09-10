---
title: "Diretrizes de Testes Automatizados para Desenvolvedores"
domain: "development"
status: "accepted"
owner: "Luciano Jr / Nicolle"
last_updated: "2026-08-27"
---

# 🧪 Diretrizes de Testes Automatizados para Desenvolvedores

Guia prático para implementação de testes unitários e de integração no dia a dia de desenvolvimento.

---

## 1. Padrão AAA (Arrange, Act, Assert)
Todo teste automatizado deve seguir a estrutura clássica de 3 blocos:
```typescript
describe('EvaluationService.calculateFinalGrade', () => {
  it('deve calcular a média ponderada correta a partir das notas das rubricas', () => {
    // Arrange (Preparação do cenário)
    const grades = { technical: 8.0, presentation: 9.0, artifact: 10.0 };
    const service = new EvaluationService();

    // Act (Execução da lógica de negócio)
    const result = service.calculateFinalGrade(grades);

    // Assert (Verificação do resultado esperado)
    expect(result).toBe(8.8);
  });
});
```

---

## 2. Testes de Integração com Testcontainers
Para rotas de API que interagem com o banco de dados PostgreSQL, utilize `Testcontainers` para subir uma instância Docker efêmera e isolada, garantindo testes fiéis sem mocks falsos de banco:
```typescript
import { PostgreSqlContainer } from '@testcontainers/postgresql';
import request from 'supertest';

describe('POST /api/v1/auth/login (Integration)', () => {
  let container;
  let app;

  beforeAll(async () => {
    container = await new PostgreSqlContainer('postgres:16-alpine').start();
    // inicializa app NestJS apontando para o container.getConnectionUri()
  });

  afterAll(async () => {
    await container.stop();
  });

  it('deve retornar 200 e tokens JWT válidos com credenciais corretas', async () => {
    const res = await request(app.getHttpServer())
      .post('/api/v1/auth/login')
      .send({ email: 'aluno@universidade.edu.br', password: 'SenhaValida@123' });

    expect(res.status).toBe(200);
    expect(res.body.data).toHaveProperty('accessToken');
  });
});
```

---

## 3. Comandos de Testes Úteis
* Executar todos os testes: `pnpm turbo run test`
* Executar testes com cobertura: `pnpm turbo run test:coverage`
* Executar testes em modo watch: `pnpm --filter api-server test:watch`

---

## 4. Documentos Relacionados
* [Estratégia Global de Qualidade](../08-quality/strategy.md)
* [Testes Unitários](../08-quality/unit-tests.md)
* [Testes de Integração](../08-quality/integration-tests.md)
