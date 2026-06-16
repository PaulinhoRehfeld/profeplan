# Playbook de Incidentes e Resolução - PROFEPLAN V4

Este playbook orienta a equipe de operações e engenharia sobre como responder a incidentes relacionados à camada do BFF (Azure Functions), falhas na geração de PDI e inconsistências de banco de dados.

---

## 1. Classificação de Severidade

| Severidade | Descrição | Impacto | Ação Recomendada |
| :--- | :--- | :--- | :--- |
| **SEV 1 (Crítica)** | Queda total do BFF ou falha generalizada em autenticação e login de professores. | Usuários não conseguem acessar a plataforma. | Acionar equipe de infraestrutura imediatamente, verificar slots de deploy da Azure. |
| **SEV 2 (Alta)** | BFF offline ou respondendo com erro 500 em endpoints de PDI, mas com fallback local funcionando. | Usuários conseguem gerar PDI, mas chaves de IA voltam a ser consumidas no frontend. | Verificar logs no App Insights, analisar chaves de API da OpenAI/Gemini. |
| **SEV 3 (Média)** | Lentidão na geração (tempo de resposta > 15s) ou falha pontual em tabela de analytics. | Degradamento sutil da experiência. | Verificar cotas de IA e logs de concorrência. |

---

## 2. Diagnóstico Rápido do BFF (Azure Functions)

Se as requisições de PDI estiverem retornando erros para o cliente:

1. **Checar Logs do Application Insights**:
   * Procure por falhas em operações contendo `/api/pdiProxy`.
   * Identifique exceções associadas à classe `AiPdiService` ou à biblioteca DLP `privacy`.
2. **Checar Endpoint de Health**:
   * Execute uma requisição GET rápida no endpoint de healthcheck do BFF para validar a conectividade externa.
3. **Erros Comuns de IA**:
   * **Erro `429 Too Many Requests`**: A cota do Azure OpenAI ou do Gemini API Key expirou.
   * **Erro `401 Unauthorized`**: O token JWT do professor expirou ou a chave pública do Supabase mudou.

---

## 3. Override de Segurança: Desativação Rápida (Circuit Breaker)

Se o BFF estiver instável ou offline e você desejar desviar todo o tráfego de geração de PDI de volta para o processamento local (frontend) imediatamente:

### A) Desativação Individual (Por Professor)
Se apenas um professor relatar falha constante, remova a flag `pdi_bff` de seu perfil:
```sql
UPDATE profiles 
SET allowed_features = array_remove(allowed_features, 'pdi_bff') 
WHERE id = 'ID_DO_USUARIO_PROFESSOR';
```

### B) Desativação Global (Desligamento de Emergência)
Se precisar desligar a integração com o BFF para todos os usuários temporariamente:
```sql
UPDATE profiles 
SET allowed_features = array_remove(allowed_features, 'pdi_bff');
```
*Isso forçará o método `shouldUseBff` no frontend a retornar `false` para todas as requisições, ativando o fallback automático sem necessidade de novo deploy.*

---

## 4. Reversão de Banco de Dados (Rollback de Dados Auxiliares)

Se a migração de dados de logs e analytics (Sprint 5) apresentar dados duplicados ou corrompidos:

1. Acesse o servidor ou terminal onde os scripts foram executados.
2. Execute o rollback das tabelas no novo banco utilizando o script dedicado:
   ```bash
   python scripts/migrations/rollback_auxiliary_tables.py
   ```
   *Nota: O script executará um comando `TRUNCATE` em cascata nas tabelas `user_feedback_preferences`, `ai_preference_logs`, `simulation_search_events` e `simulation_question_views` no banco destino (`NEW_DB_URL`).*
3. Corrija o arquivo de carga ou os filtros e tente a migração novamente.
