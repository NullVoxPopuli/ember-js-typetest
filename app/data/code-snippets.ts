export interface CodeSnippet {
  id: string;
  code: string;
  description: string;
}

export const CODE_SNIPPETS: CodeSnippet[] = [
  {
    id: 'arrow-function',
    code: 'const sum = (a, b) => a + b;',
    description: 'Arrow function',
  },
  {
    id: 'async-await',
    code: 'async function fetchData() {\n  return await api.get("/data");\n}',
    description: 'Async/await function',
  },
  {
    id: 'destructuring',
    code: 'const { name, age } = user;',
    description: 'Object destructuring',
  },
  {
    id: 'array-methods',
    code: 'items.map(x => x.value).filter(v => v > 0)',
    description: 'Array methods chaining',
  },
  {
    id: 'template-literal',
    code: 'const msg = `Hello, ${name}!`;',
    description: 'Template literal',
  },
  {
    id: 'promise-chain',
    code: 'fetch(url).then(r => r.json()).catch(console.error)',
    description: 'Promise chain',
  },
  {
    id: 'class-definition',
    code: 'class Component {\n  constructor(props) {\n    this.props = props;\n  }\n}',
    description: 'Class definition',
  },
  {
    id: 'for-loop',
    code: 'for (let i = 0; i < arr.length; i++) {\n  console.log(arr[i]);\n}',
    description: 'For loop',
  },
  {
    id: 'object-literal',
    code: 'const config = {\n  url: "/api",\n  method: "POST"\n};',
    description: 'Object literal',
  },
  {
    id: 'ternary-operator',
    code: 'const result = condition ? "yes" : "no";',
    description: 'Ternary operator',
  },
  {
    id: 'array-find',
    code: 'const user = users.find(u => u.id === targetId);',
    description: 'Array find method',
  },
  {
    id: 'event-listener',
    code: 'button.addEventListener("click", handleClick);',
    description: 'Event listener',
  },
  {
    id: 'spread-operator',
    code: 'const newArray = [...oldArray, newItem];',
    description: 'Spread operator',
  },
  {
    id: 'try-catch',
    code: 'try {\n  risky();\n} catch (error) {\n  console.error(error);\n}',
    description: 'Try-catch block',
  },
  {
    id: 'json-parse',
    code: 'const data = JSON.parse(jsonString);',
    description: 'JSON parsing',
  },
];

export function getRandomSnippet(): CodeSnippet {
  const randomIndex = Math.floor(Math.random() * CODE_SNIPPETS.length);
  const snippet = CODE_SNIPPETS[randomIndex];

  if (!snippet) {
    throw new Error('No code snippets available');
  }

  return snippet;
}
