# Contributing to SpendShare

First off, thank you for considering contributing to SpendShare! It's people like you that make SpendShare such a great tool. We welcome contributions from everyone, whether you're a seasoned developer or just getting started.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to conduct@spendshare.com.

### Our Standards

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on what is best for the community
- Show empathy towards other community members
- Be constructive in feedback

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

**Bug Report Template:**

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
 - OS: [e.g. iOS, Windows, macOS]
 - Browser: [e.g. chrome, safari]
 - Version: [e.g. 22]
 - Device: [e.g. iPhone 12, Desktop]

**Additional context**
Any other relevant information.
```

### Suggesting Features

We love feature suggestions! Before creating a feature request:

1. Check if it's already been requested
2. Consider if it fits the project scope
3. Think about how it benefits all users

**Feature Request Template:**

```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
A clear description of what you want to happen.

**Describe alternatives you've considered**
Alternative solutions or features you've considered.

**Additional context**
Any other context, mockups, or screenshots.
```

### Contributing Code

1. **Find an issue to work on** or create a new one
2. **Comment on the issue** to let others know you're working on it
3. **Fork the repository** and create your branch
4. **Make your changes** following our coding standards
5. **Test your changes** thoroughly
6. **Submit a pull request**

## Getting Started

### Prerequisites

- Node.js 18+ LTS
- Python 3.10+
- Docker Desktop
- Git
- A code editor (VS Code recommended)

### Setup Development Environment

```bash
# 1. Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/SpendShare.git
cd SpendShare

# 2. Install dependencies
npm install

# 3. Set up environment variables
cp .env.example .env
# Edit .env with your local settings

# 4. Start Docker services
docker-compose -f docker-compose.dev.yml up -d

# 5. Run database migrations
npm run migrate

# 6. Start development server
npm run dev
```

See [SETUP.md](./SETUP.md) for detailed instructions.

## Development Workflow

### Branch Naming Convention

Use descriptive branch names with prefixes:

- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Adding or updating tests
- `chore/` - Maintenance tasks

Examples:
```
feature/receipt-scanning
fix/expense-calculation-error
docs/update-setup-guide
refactor/user-service-cleanup
test/add-auth-service-tests
chore/update-dependencies
```

### Development Process

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes**
   - Write clean, readable code
   - Follow coding standards
   - Add tests for new features
   - Update documentation

3. **Test locally**
   ```bash
   npm run test
   npm run lint
   npm run build
   ```

4. **Commit changes**
   ```bash
   git add .
   git commit -m "feat: add receipt scanning feature"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**
   - Fill out the PR template
   - Link related issues
   - Request reviews

## Coding Standards

### TypeScript/JavaScript

- Use TypeScript for type safety
- Follow ESLint configuration
- Use Prettier for formatting
- Prefer functional components and hooks
- Use async/await over promises
- Handle errors gracefully

**Example:**

```typescript
// Good
async function createExpense(data: CreateExpenseDto): Promise<Expense> {
  try {
    const expense = await expenseRepository.create(data);
    await notificationService.notifyGroupMembers(expense.groupId);
    return expense;
  } catch (error) {
    logger.error('Failed to create expense', { error, data });
    throw new ExpenseCreationError('Unable to create expense');
  }
}

// Avoid
function createExpense(data) {
  return expenseRepository.create(data)
    .then(expense => {
      notificationService.notifyGroupMembers(expense.groupId);
      return expense;
    })
    .catch(error => {
      console.log(error);
      throw error;
    });
}
```

### Python

- Follow PEP 8 style guide
- Use type hints
- Write docstrings for functions/classes
- Use meaningful variable names

**Example:**

```python
# Good
def extract_receipt_data(image_path: str) -> ReceiptData:
    """
    Extract structured data from receipt image using OCR.
    
    Args:
        image_path: Path to the receipt image file
        
    Returns:
        ReceiptData object containing extracted information
        
    Raises:
        OCRError: If image processing fails
    """
    try:
        image = preprocess_image(image_path)
        text = perform_ocr(image)
        return parse_receipt_text(text)
    except Exception as e:
        logger.error(f"OCR failed for {image_path}: {e}")
        raise OCRError("Failed to process receipt") from e
```

### React/React Native

- Use functional components
- Implement proper prop types
- Keep components small and focused
- Use custom hooks for shared logic
- Implement proper loading and error states

**Example:**

```typescript
// Good
interface ExpenseListProps {
  groupId: string;
  onExpenseClick: (expense: Expense) => void;
}

export const ExpenseList: React.FC<ExpenseListProps> = ({
  groupId,
  onExpenseClick,
}) => {
  const { data: expenses, isLoading, error } = useExpenses(groupId);

  if (isLoading) return <LoadingSpinner />;
  if (error) return <ErrorMessage error={error} />;
  if (!expenses?.length) return <EmptyState message="No expenses yet" />;

  return (
    <List>
      {expenses.map((expense) => (
        <ExpenseItem
          key={expense.id}
          expense={expense}
          onClick={() => onExpenseClick(expense)}
        />
      ))}
    </List>
  );
};
```

### File Naming

- **Components**: PascalCase (`ExpenseCard.tsx`)
- **Utilities**: camelCase (`dateUtils.ts`)
- **Constants**: UPPER_SNAKE_CASE (`API_ENDPOINTS.ts`)
- **Types/Interfaces**: PascalCase (`Expense.ts`)

### Project Structure

```
src/
├── components/       # Reusable UI components
├── pages/           # Page components
├── hooks/           # Custom React hooks
├── services/        # API services
├── store/           # Redux store
├── types/           # TypeScript types
├── utils/           # Utility functions
├── constants/       # Constants
├── styles/          # Global styles
└── tests/           # Test files
```

## Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements

### Examples

```bash
# Feature
git commit -m "feat(expense): add recurring expense support"

# Bug fix
git commit -m "fix(auth): resolve token refresh issue"

# Documentation
git commit -m "docs(readme): update installation instructions"

# Breaking change
git commit -m "feat(api): change expense API response format

BREAKING CHANGE: expense API now returns amount as string instead of number"
```

## Pull Request Process

### Before Submitting

- [ ] Code compiles without errors
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] No console.log or debug code
- [ ] Code follows style guidelines
- [ ] Commits follow commit guidelines

### PR Template

```markdown
## Description
Brief description of changes.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issues
Closes #123

## How Has This Been Tested?
Describe the tests you ran.

## Screenshots (if applicable)
Add screenshots for UI changes.

## Checklist
- [ ] My code follows the project style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code where needed
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests
- [ ] All tests pass locally
```

### Review Process

1. **Automated checks** must pass (linting, tests, build)
2. **At least one approval** from a maintainer
3. **No merge conflicts** with main branch
4. **CI/CD pipeline** passes successfully

### After Approval

- Maintainers will merge your PR
- Your contribution will be included in the next release
- You'll be added to the contributors list

## Testing

### Running Tests

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage

# Run specific test file
npm test -- ExpenseService.test.ts
```

### Writing Tests

- Write tests for all new features
- Aim for >80% code coverage
- Test edge cases and error conditions
- Use descriptive test names

**Example:**

```typescript
describe('ExpenseService', () => {
  describe('createExpense', () => {
    it('should create expense with valid data', async () => {
      const data = {
        amount: 100,
        description: 'Dinner',
        groupId: 'group-123',
      };
      
      const expense = await expenseService.create(data);
      
      expect(expense).toBeDefined();
      expect(expense.amount).toBe(100);
      expect(expense.description).toBe('Dinner');
    });

    it('should throw error with invalid amount', async () => {
      const data = {
        amount: -100,
        description: 'Dinner',
        groupId: 'group-123',
      };
      
      await expect(expenseService.create(data))
        .rejects
        .toThrow('Amount must be positive');
    });

    it('should notify group members after creation', async () => {
      const data = { /* ... */ };
      
      await expenseService.create(data);
      
      expect(notificationService.notifyGroupMembers)
        .toHaveBeenCalledWith('group-123');
    });
  });
});
```

## Documentation

### Code Documentation

- Add JSDoc/TSDoc comments for public APIs
- Explain complex logic with inline comments
- Keep comments up to date with code changes

### User Documentation

- Update README for user-facing changes
- Add examples for new features
- Update API documentation
- Include screenshots for UI changes

### Architecture Documentation

- Update ARCHITECTURE.md for architectural changes
- Document design decisions
- Explain trade-offs

## Recognition

Contributors will be recognized in:

- GitHub contributors page
- CONTRIBUTORS.md file
- Release notes
- Annual contributor highlight

## Questions?

- **General questions**: [GitHub Discussions](https://github.com/gohbi/SpendShare/discussions)
- **Bug reports**: [GitHub Issues](https://github.com/gohbi/SpendShare/issues)
- **Security issues**: security@spendshare.com (private)
- **Other inquiries**: contribute@spendshare.com

## Resources

- [Setup Guide](./SETUP.md)
- [Architecture Overview](./ARCHITECTURE.md)
- [Technology Stack](./TECH_STACK.md)
- [Roadmap](./ROADMAP.md)

---

Thank you for contributing to SpendShare! 🎉
