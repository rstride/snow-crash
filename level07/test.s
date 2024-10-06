	.file	"test.c"
	.text
	.section	.rodata
.LC0:
	.string	"LOGNAME"
.LC1:
	.string	"/bin/echo %s "
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movl	$0, %eax
	call	getegid@PLT
	movl	%eax, -4(%rbp)
	movl	$0, %eax
	call	geteuid@PLT
	movl	%eax, -8(%rbp)
	movl	-4(%rbp), %edx
	movl	-4(%rbp), %ecx
	movl	-4(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	setresgid@PLT
	movl	-8(%rbp), %edx
	movl	-8(%rbp), %ecx
	movl	-8(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	setresuid@PLT
	movq	$0, -32(%rbp)
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rdx
	leaq	-32(%rbp), %rax
	leaq	.LC1(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	asprintf@PLT
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	system@PLT
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (Debian 13.3.0-3) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
