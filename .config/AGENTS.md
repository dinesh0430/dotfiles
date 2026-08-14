# Parent Config Directory Rules (~/.config/AGENTS.md)

## 1. Dotfiles Repository & Git Invocation

The dotfiles repository is tracked as a bare Git directory at `$HOME/.config/.git` with `$HOME` as the working tree.

Standard `git` commands executed directly inside subdirectories without specifying the Git directory and work tree will fail with work-tree errors. Always use the full dotfiles invocation parameters:

* **Dotfiles Git Command**:
  ```bash
  git --git-dir=$HOME/.config/.git --work-tree=$HOME <command>
  ```
  *(Configured as alias `cfg` in zsh)*

* **Dotfiles Lazygit Command**:
  ```bash
  lazygit --git-dir=$HOME/.config/.git --work-tree=$HOME
  ```
  *(Configured as alias `cflg` in zsh)*

---

## 2. Git Operation Policies

* **Execute Git Commands Only When Explicitly Requested**:
  * Do **NOT** run proactive `git status`, `git diff`, `git add`, or `git commit` commands during standard code lookups, queries, or edits unless the user explicitly requests Git actions.
* **Post-Change Commit Suggestions**:
  * After completing code changes, simply inform the user that the changes can be committed once they have tested and confirmed that everything is working as intended (e.g., *"Once you test and confirm the changes are working as intended, let me know and we can commit them."*).
  * Do **NOT** run git commands or perform commits until the user gives explicit confirmation and approval.

---

## 3. Git Commit Workflow & Message Guidelines

When the user asks to commit changes, follow these exact steps:

1. **Inspect Staged/Unstaged Changes**:
   * Run `git --git-dir=$HOME/.config/.git --work-tree=$HOME status` and `diff` (or `diff --cached`) to analyze exact modifications.

2. **Message Formatting Guidelines**:
   * **Header/Summary**:
     * Keep to 50–72 characters.
     * Follow conventional commit format `<type>(<scope>): <short description>` using lowercase and imperative mood (e.g., `feat(ui): add search bar`, `refactor(zsh): move completion scripts`).
   * **Body/Description**:
     * Separate the header from the body with a blank line.
     * Include a clear explanation of *what* was modified and the rationale/context (*why*) behind the change.
     * Can contain multiple paragraphs if needed.
   * **Example**:
     ```
     refactor(zsh): move completion scripts to custom_completions

     Move _flash_sofle from $ZDOTDIR/functions to $ZDOTDIR/custom_completions and update fpath in ~/.config/zsh/.zshrc.

     This keeps completion definitions separate from general shell functions.
     ```

3. **Executing the Commit**:
   * Stage relevant files:
     ```bash
     git --git-dir=$HOME/.config/.git --work-tree=$HOME add <files...>
     ```
   * Commit with multiple `-m` flags to separate subject line and body paragraphs cleanly:
     ```bash
     git --git-dir=$HOME/.config/.git --work-tree=$HOME commit -m "<Short summary line>" \
                -m "<Detailed body paragraph 1>" \
                -m "<Detailed body paragraph 2>"
     ```

4. **Post-Commit Verification**:
   * Run `git --git-dir=$HOME/.config/.git --work-tree=$HOME log -n 1` to verify the committed message format and output the result to the user.
