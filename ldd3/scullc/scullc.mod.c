#include <linux/module.h>
#define INCLUDE_VERMAGIC
#include <linux/build-salt.h>
#include <linux/elfnote-lto.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

BUILD_SALT;
BUILD_LTO_INFO;

MODULE_INFO(vermagic, VERMAGIC_STRING);
MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__section(".gnu.linkonce.this_module") = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

#ifdef CONFIG_RETPOLINE
MODULE_INFO(retpoline, "Y");
#endif

static const struct modversion_info ____versions[]
__used __section("__versions") = {
	{ 0xd9726f80, "module_layout" },
	{ 0x2d3385d3, "system_wq" },
	{ 0xac799dd1, "kmem_cache_destroy" },
	{ 0x1bcee483, "cdev_del" },
	{ 0x36c11c94, "kmalloc_caches" },
	{ 0xeb233a45, "__kmalloc" },
	{ 0x4240b5cb, "cdev_init" },
	{ 0x4caf37f7, "param_ops_int" },
	{ 0x3fd78f3b, "register_chrdev_region" },
	{ 0x8d6aff89, "__put_user_nocheck_4" },
	{ 0xffeedf6a, "delayed_work_timer_fn" },
	{ 0xc6f46339, "init_timer_key" },
	{ 0x3a099605, "__get_user_nocheck_4" },
	{ 0x409bcb62, "mutex_unlock" },
	{ 0x6091b333, "unregister_chrdev_region" },
	{ 0x6b10bee1, "_copy_to_user" },
	{ 0xfb578fc5, "memset" },
	{ 0xb5136dc7, "mutex_lock_interruptible" },
	{ 0x977f511b, "__mutex_init" },
	{ 0xc5850110, "printk" },
	{ 0x18732c09, "kmem_cache_free" },
	{ 0x1a21ea6, "generic_file_read_iter" },
	{ 0xd5f10699, "cdev_add" },
	{ 0xdf6d705a, "kmem_cache_alloc" },
	{ 0xb2fcb56d, "queue_delayed_work_on" },
	{ 0xc959d152, "__stack_chk_fail" },
	{ 0xbdfb6dbb, "__fentry__" },
	{ 0x69ecc112, "kmem_cache_alloc_trace" },
	{ 0x8fc2a09, "kmem_cache_create" },
	{ 0x92c06de7, "generic_file_write_iter" },
	{ 0x37a0cba, "kfree" },
	{ 0x14fc13d4, "remap_pfn_range" },
	{ 0x13c49cc2, "_copy_from_user" },
	{ 0x88db9f48, "__check_object_size" },
	{ 0xe3ec2f2b, "alloc_chrdev_region" },
};

MODULE_INFO(depends, "");


MODULE_INFO(srcversion, "B90C71D704167F6C673C824");
